import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sretnesapice_mobile/models/paypal/amount.dart';
import 'package:sretnesapice_mobile/models/paypal/details.dart';
import 'package:sretnesapice_mobile/models/paypal/item_list.dart';
import 'package:sretnesapice_mobile/models/paypal/items.dart';
import 'package:sretnesapice_mobile/models/paypal/payment_gateway_data.dart';
import 'package:sretnesapice_mobile/models/paypal/transaction.dart';
import 'package:sretnesapice_mobile/requests/payment_request.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
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
  String? CLIENT_ID = dotenv.env['CLIENT_ID_VALUE'];
  String? SECRET_KEY = dotenv.env['SECRET_KEY_VALUE'];
  static const RETURN_URL = String.fromEnvironment("RETURN_URL_VALUE",
      defaultValue: 'success.snippetcoder.com');
  static const CANCEL_URL = String.fromEnvironment("CANCEL_URL_VALUE",
      defaultValue: 'cancel.snippetcoder.com');
  static const PAYPAL_NOTE = String.fromEnvironment('PAYPAL_NOTE_VALUE',
      defaultValue: 'Dodjite nam opet!');

  static const CURRENCY =
      String.fromEnvironment('DEFAULT_CURRENCY_VALUE', defaultValue: 'USD');
  static const BUSSINESS_NAME = String.fromEnvironment('BUSSINESS_NAME_VALUE',
      defaultValue: 'Sretne Šapice');
  static const BUSSINESS_ADDRESS = String.fromEnvironment(
      'BUSSINESS_ADDRESS_VALUE',
      defaultValue: 'Dr Ante Starčevića 50, Mostar, BiH');
  static const BUSSINESS_CONTACT_INFO = String.fromEnvironment(
      'BUSSINESS_CONTACT_INFO_VALUE',
      defaultValue: '+387 62 003 655');

  OrderProvider? _orderProvider;
  OrderItemProvider? _orderItemProvider;
  UserShippingInformationProvider? _userShippingInformationProvider;
  PaymentProvider? _paymentProvider;
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
  final int selectedIndex = 2;
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
          await _orderProvider!.get({'userId': Authorization.user!.userId});

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

      await loadData();
    } catch (e) {
      errorDialog(context, e);
    }
  }

  void deleteOrderItem(int orderItemId) async {
    try {
      await _orderItemProvider!.hardDelete(orderItemId);

      await loadData();
    } catch (e) {
      errorDialog(context, e);
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

        paymentRequest.orderId = cart!.orderId;
        paymentRequest.paymentMethod = _paymentMethod == PaymentMethod.paypal
            ? "Paypal"
            : "CashOnDelivery";
        paymentRequest.status = "Pending";
        paymentRequest.amount = cart!.totalAmount;

        int existingPaymentId = await _paymentProvider!
            .paymentWithOrderIdExists(paymentRequest.orderId!);

        if (existingPaymentId != 0) {
          await _paymentProvider?.update(existingPaymentId, paymentRequest);
        } else {
          await _paymentProvider!.insert(paymentRequest);
        }

        if (_paymentMethod == PaymentMethod.paypal) {
          var transaction = createNewTransaction(cart!);

          _openPaypalGateway(context, transaction, cart!);
        } else if (_paymentMethod == PaymentMethod.cashOnDelivery) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Narudžba obrađena'),
              content: Text('Uspješno ste napravili narudžbu!'),
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
        errorDialog(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: selectedIndex,
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Text(
                    showShippingInfoForm ? "PODACI ZA DOSTAVU" : "CHECKOUT",
                    style: TextStyle(fontSize: 30, color: Color(0xff315ccc)),
                  )),
                ),
                if (cart == null ||
                    cart!.orderItems == null ||
                    cart!.orderItems!.isEmpty)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    height: 200,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Korpa je prazna!",
                          style:
                              TextStyle(fontSize: 24, color: Color(0xff315ccc)),
                        ),
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
                          const Divider(
                            color: Color(0xff315ccc),
                            thickness: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "TOTAL",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff315ccc),
                                ),
                              ),
                              Text(
                                "${cart?.totalAmount} KM",
                                style: const TextStyle(
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
              title: Text('PayPal'),
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
              title: Text('Plaćanje pouzećem'),
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

  Transaction createNewTransaction(Order cart) {
    var currency = CURRENCY;
    var total = cart.totalAmount!;
    var subtotal = cart.totalAmount!;
    var details = Details(subtotal);
    var amount = Amount(total, currency, details);

    List<Items> items = [];
    cart.orderItems?.forEach((orderItem) {
      var item = Items(orderItem.product!.name!, orderItem.quantity!,
          orderItem.product!.price!, currency);
      items.add(item);
    });

    var itemList = ItemList(items);
    var transaction =
        Transaction(amount, itemList, description: "Novo plaćanje");
    return transaction;
  }

  void _openPaypalGateway(
      BuildContext context, Transaction transaction, Order selectedOrder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckout(
          sandboxMode: true,
          clientId: CLIENT_ID,
          secretKey: SECRET_KEY,
          returnURL: RETURN_URL,
          cancelURL: CANCEL_URL,
          transactions: [transaction],
          note: PAYPAL_NOTE,
          onSuccess: (Map params) async {
            if (!mounted) return;
            try {
              var paymentGatewayData = PaymentGatewayData(
                params["data"].toString(),
                params["message"].toString(),
                params["error"],
              );

              String transactionId = params["data"]["id"];

              await _updatePaymentWithTransactionId(
                  selectedOrder.orderId!, transactionId);

              await _paymentProvider!.completePayment(selectedOrder.orderId!);
              await _orderProvider!.paidOrder(selectedOrder.orderId!);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Plaćanje je uspješno procesuirano",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Desila se greška prilikom obrade uspjeha plaćanja",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Desila se greška prilikom procesuiranja plaćanja. Molimo kontaktirajte administratora",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );

            Navigator.pop(context);
          },
          onCancel: () async {
            await _paymentProvider!.cancelPayment(selectedOrder.orderId!);
          },
        ),
      ),
    );
  }

  Future<void> _updatePaymentWithTransactionId(
      int orderId, String transactionId) async {
    try {
      await _paymentProvider!.updateTransactionId(orderId, transactionId);
    } catch (e) {
      print("Error updating payment record: $e");
    }
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
