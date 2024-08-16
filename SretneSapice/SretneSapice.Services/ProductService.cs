using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace SretneSapice.Services
{
    public class ProductService : BaseCRUDService<ProductDto, Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>, IProductService
    {
        private readonly IOrderService _orderService;
        public ProductService(_180148Context context, IMapper mapper, IOrderService orderService) : base(context, mapper)
        {
            _orderService = orderService;
        }

        public override async Task BeforeInsert(Product entity, ProductInsertRequest insert)
        {
            entity.CreatedDate = DateTime.Now;
        }

        public override IQueryable<Product> AddInclude(IQueryable<Product> query, ProductSearchObject? search = null)
        {
            query = query.Include(x => x.ProductType);
            return base.AddInclude(query, search);
        }

        public override IQueryable<Product> AddFilter(IQueryable<Product> query, ProductSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (search?.Top5 == true)
            {
                var topProductIds = _context.OrderItems
                                    .GroupBy(oi => oi.ProductId)
                                    .Select(g => new { ProductId = g.Key, OrderItemCount = g.Count() })
                                    .OrderByDescending(g => g.OrderItemCount)
                                    .Take(5)
                                    .Select(g => g.ProductId)
                                    .ToList();

                query = query.Where(p => topProductIds.Contains(p.ProductId))
                             .Include(p => p.ProductType);
            }

            if(search?.Newest == true)
            {
                query = query.OrderByDescending(p => p.CreatedDate);
            }

            if (search?.PriceLtoH == true)
            {
                query = query.OrderBy(p => p.Price);
            }

            if (search?.PriceHtoL == true)
            {
                query = query.OrderByDescending(p => p.Price);
            }

            return base.AddFilter(query, search);
        }

        public override async Task<ProductDto> Update(int id, ProductUpdateRequest update)
        {
            var set = _context.Set<Product>();

            var product = await set.FindAsync(id);

            if (product is null)
                throw new InvalidOperationException();

            var oldPrice = product.Price;
            _mapper.Map(update, product);

            await _context.SaveChangesAsync();

            if (product.Price != oldPrice)
            {
                var orderItems = _context.OrderItems
                    .Include(x => x.Order)
                    .Where(oi => oi.ProductId == id && oi.Order.Status == "In Cart")
                    .ToList();

                var affectedOrderIds = new HashSet<int>();

                foreach (var item in orderItems)
                {
                    item.Subtotal = item.Quantity * product.Price;

                    await _context.SaveChangesAsync();

                    affectedOrderIds.Add(item.Order.OrderId);
                }

                var affectedOrders = _context.Orders
                    .Where(o => affectedOrderIds.Contains(o.OrderId))
                    .ToList();

                foreach (var order in affectedOrders)
                {
                    await _orderService.UpdateTotalAmount(order.OrderId);
                }
            }

            return _mapper.Map<ProductDto>(product);
        }

        static object isLocked = new object();
        static MLContext mlContext = null;
        static ITransformer model = null;

        public List<ProductDto> Recommend(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Orders.Include(o => o.OrderItems).ToList();

                    if (!tmpData.Any())
                    {
                        throw new InvalidOperationException("No orders found in the database.");
                    }

                    var data = new List<ProductEntry>();


                    foreach (var x in tmpData)
                    {
                        if (x.OrderItems.Count > 1)
                        {
                            var distinctItemId = x.OrderItems.Select(y => y.ProductId).Distinct().ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = x.OrderItems.Where(z => z.ProductId != y).Select(oi => oi.ProductId).Distinct();
                                foreach (var z in relatedItems)
                                {
                                    data.Add(new ProductEntry()
                                    {
                                        ProductId = (uint)y,
                                        CoPurchaseProductID = (uint)z,
                                        Label = 1.0f
                                    });
                                }
                            });
                        }
                    }

                    if (data.Count == 0)
                    {
                        throw new InvalidOperationException("No valid data found for training.");
                    }

                    Console.WriteLine($"Data count: {data.Count}");

                    var traindata = mlContext.Data.LoadFromEnumerable(data);

                    //STEP 3: Your data is already encoded so all you need to do is specify options for MatrxiFactorizationTrainer with a few extra hyperparameters
                    //        LossFunction, Alpa, Lambda and a few others like K and C as shown below and call the trainer.
                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductId);
                    options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    // For better results use the following parameters
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(traindata);

                }
            }




            //prediction

            var products = _context.Products.Where(x => x.ProductId != id);

            var predictionResult = new List<Tuple<Product, float>>();

            var predictionEngine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);

            foreach (var product in products)
            {

                var prediction = predictionEngine.Predict(
                                         new ProductEntry()
                                         {
                                             ProductId = (uint)id,
                                             CoPurchaseProductID = (uint)product.ProductId
                                         });


                predictionResult.Add(new Tuple<Product, float>(product, prediction.Score));
            }


            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return _mapper.Map<List<ProductDto>>(finalResult);

        }


    }
    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry
    {
        [KeyType(count: 10)]
        public uint ProductId { get; set; }

        [KeyType(count: 10)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; }
    }
}
