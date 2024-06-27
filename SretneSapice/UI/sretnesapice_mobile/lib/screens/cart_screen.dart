import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/requests/payment_request.dart';
import 'package:sretnesapice_mobile/screens/product_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/order.dart';
import 'package:sretnesapice_mobile/providers/order_item_provider.dart';
import 'package:sretnesapice_mobile/providers/order_provider.dart';
import 'package:sretnesapice_mobile/providers/payment_provider.dart';
import 'package:sretnesapice_mobile/providers/user_shipping_information_provider.dart';
import 'package:sretnesapice_mobile/requests/order_item_update_request.dart';
import 'package:sretnesapice_mobile/requests/user_shipping_info_request.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';
import 'package:sretnesapice_mobile/widgets/order_item_card.dart';
import 'package:sretnesapice_mobile/widgets/text_input_widget.dart';

enum PaymentMethod {
  paypal,
  cashOnDelivery,
}

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart";
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  OrderProvider? _orderProvider = null;
  OrderItemProvider? _orderItemProvider = null;
  UserShippingInformationProvider? _userShippingInformationProvider = null;
  PaymentProvider? _paymentProvider = null;
  Order? cart;

  OrderItemUpdateRequest orderItemUpdate = new OrderItemUpdateRequest();
  UserShippingInfoRequest userShippingInfoRequest =
      new UserShippingInfoRequest();
  PaymentRequest paymentRequest = new PaymentRequest();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool showShippingInfoForm = false;
  final _formKey = GlobalKey<FormState>();

  PaymentMethod _paymentMethod = PaymentMethod.paypal;

  @override
  void initState() {
    super.initState();
    _orderProvider = context.read<OrderProvider>();
    _orderItemProvider = context.read<OrderItemProvider>();
    _userShippingInformationProvider =
        context.read<UserShippingInformationProvider>();
    _paymentProvider = context.read<PaymentProvider>();

    loadData();
  }

  Future loadData() async {
    if (Authorization.user?.userId != null) {
      var orderData =
          await _orderProvider!.get({'userId': Authorization.user!.userId!});

      if (orderData.isNotEmpty) {
        setState(() {
          cart = orderData.first;
        });
      }
    }
  }

  Future<void> updateQuantity(int orderItemId, int newQuantity) async {
    try {
      orderItemUpdate.quantity = newQuantity;
      await _orderItemProvider!.update(orderItemId, orderItemUpdate);
      print("Uspjesno");
      await loadData();
    } catch (e) {
      print('Greška!');
    }
  }

  void deleteOrderItem(int orderItemId) async {
    try {
      await _orderProvider!.hardDelete(orderItemId);
      print("Uspjesno");
      await loadData();
    } catch (e) {
      print("Greška!");
    }
  }

  Future<void> submitOrder() async {
    if (_formKey.currentState!.validate()) {
      userShippingInfoRequest.address = _addressController.text;
      userShippingInfoRequest.city = _cityController.text;
      userShippingInfoRequest.zipcode = _zipController.text;
      userShippingInfoRequest.phone = _phoneController.text;

      try {
        await _userShippingInformationProvider!.insert(userShippingInfoRequest);

        if (_paymentMethod == PaymentMethod.paypal) {
          var paypalUrl =
              await _paymentProvider!.initiatePayment(cart!.orderId!);
          if (paypalUrl != null) {
            Uri paypalUri = Uri.parse(paypalUrl);
            if (await canLaunchUrl(paypalUri)) {
              await launchUrl(paypalUri);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductListScreen()
                ),
              );
            } else {
              throw 'Could not launch $paypalUrl';
            }
          }
        } else if (_paymentMethod == PaymentMethod.cashOnDelivery) {
          paymentRequest.orderId = cart!.orderId;
          paymentRequest.paymentMethod = "cashOnDelivery";
          paymentRequest.status = "Pending";
          paymentRequest.amount = cart!.totalAmount;

          await _paymentProvider!.insert(paymentRequest);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Order Successful'),
              content: Text('Your order has been placed successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print('Error submitting order: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  showShippingInfoForm ? "PODACI ZA DOSTAVU" : "CHECKOUT",
                  style: TextStyle(fontSize: 30, color: Color(0xff315ccc)),
                )),
                if (cart == null ||
                    cart!.orderItems == null ||
                    cart!.orderItems!.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Korpa je prazna!",
                        style:
                            TextStyle(fontSize: 24, color: Color(0xff315ccc)),
                      ),
                    ),
                  )
                else ...[
                  if (showShippingInfoForm) _buildShippingInfoForm(),
                  if (!showShippingInfoForm)
                    Column(
                      children: [
                        if (cart != null &&
                            cart!.orderItems != null &&
                            cart!.orderItems!.isNotEmpty) ...[
                          Column(
                            children: _buildOrderItemCardList(),
                          ),
                          Divider(
                            color: Color(0xff315ccc),
                            thickness: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "TOTAL",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff315ccc),
                                ),
                              ),
                              Text(
                                "${cart?.totalAmount} KM",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff315ccc),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showShippingInfoForm = true;
                                  });
                                },
                                child: Text(
                                  'Sljedeći korak',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff315ccc),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderItemCardList() {
    if (cart == null || cart!.orderItems == null || cart!.orderItems!.isEmpty) {
      return [];
    }
    return cart!.orderItems!.map((orderItem) {
      return OrderItemCard(
        name: orderItem.product!.name,
        price: orderItem.product!.price,
        productPhoto: orderItem.product!.productPhoto,
        quantity: orderItem.quantity,
        onQuantityChanged: (newQuantity) {
          updateQuantity(orderItem.orderItemId!, newQuantity);
        },
        onDelete: () {
          deleteOrderItem(orderItem.orderItemId!);
        },
      );
    }).toList();
  }

  Widget _buildShippingInfoForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setInput(context, "Adresa", _addressController, 2, 1),
                  setInput(context, "Grad", _cityController, 2, 1),
                  setInput(context, "ZIP", _zipController, 2, 1),
                  setInput(context, "Broj telefona", _phoneController, 9, 1),
                ],
              ),
            ),
            ListTile(
              title: Text('Paypal'),
              leading: Radio(
                value: PaymentMethod.paypal,
                groupValue: _paymentMethod,
                onChanged: (PaymentMethod? value) {
                  if (value != null) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Cash on delivery'),
              leading: Radio(
                value: PaymentMethod.cashOnDelivery,
                groupValue: _paymentMethod,
                onChanged: (PaymentMethod? value) {
                  if (value != null) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: submitOrder,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xff315ccc))),
              child: Text("Završi narudžbu",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ]),
        ));
  }

  Container setInput(BuildContext context, String label,
      TextEditingController controller, int minLength, int maxLines) {
    var phoneNumber = false;

    if (label == "Broj telefona") phoneNumber = true;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            labelText: label,
            controller: controller,
            minLength: minLength,
            isEmail: false,
            isPhoneNumber: phoneNumber,
            color: Color(0xff315ccc),
            maxLines: maxLines,
          )
        ],
      ),
    );
  }
}
