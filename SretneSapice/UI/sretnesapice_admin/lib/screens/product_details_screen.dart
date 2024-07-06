import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/main.dart';
import 'package:sretnesapice_admin/models/product.dart';
import 'package:sretnesapice_admin/models/product_type.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/product_type_provider.dart';
import 'package:sretnesapice_admin/screens/product_list_screen.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';
import 'package:sretnesapice_admin/providers/product_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sretnesapice_admin/utils/util.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product? product;
  ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ProductTypeProvider _productTypeProvider;
  late ProductProvider _productProvider;

  SearchResult<ProductType>? productTypesResult;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'name': widget.product?.name,
      'code': widget.product?.code,
      'description': widget.product?.description,
      'price': widget.product?.price?.toString(),
      'stockQuantity': widget.product?.stockQuantity?.toString(),
      'productTypeID': widget.product?.productTypeID?.toString(),
      'brand': widget.product?.brand,
      'productPhoto': widget.product?.productPhoto
    };

    _productTypeProvider = context.read<ProductTypeProvider>();
    _productProvider = context.read<ProductProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    productTypesResult = await _productTypeProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: 0,
      title: this.widget.product?.name ?? "Novi proizvod",
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              isLoading ? Container() : _buildForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 53, 3, 61),
                              Color.fromARGB(255, 10, 77, 119)
                            ])),
                        child: ElevatedButton(
                          onPressed: () async {
                            _formKey.currentState?.saveAndValidate();

                            print(_formKey.currentState?.value);

                            var request =
                                new Map.from(_formKey.currentState!.value);

                            if (_base64Image != null &&
                                _base64Image!.isNotEmpty) {
                              request['productPhoto'] = _base64Image;
                            } else if (widget.product != null) {
                              request['productPhoto'] =
                                  widget.product!.productPhoto;
                            }

                            try {
                              if (widget.product == null) {
                                await _productProvider.insert(request);

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          content:
                                              Text("Proizvod uspješno dodan!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ProductListScreen(),
                                                  ),
                                                );
                                              },
                                              child: Text("OK"),
                                            )
                                          ],
                                        ));
                              } else {
                                await _productProvider.update(
                                    widget.product!.productID!, request);

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          content: Text(
                                              "Proizvod uspješno izmijenjen!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ProductListScreen(),
                                                  ),
                                                );
                                              },
                                              child: Text("OK"),
                                            )
                                          ],
                                        ));
                              }
                            } on Exception catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Error"),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("OK"))
                                        ],
                                      ));
                            }
                          },
                          child: Text("Sačuvaj",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.all(20),
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Container(
        color: Color.fromARGB(255, 223, 212, 244),
        padding: EdgeInsets.all(20),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Šifra",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 61, 6, 137),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 6, 137),
                        fontWeight: FontWeight.bold,
                      ),
                      name: "code",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: "Naziv",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 61, 6, 137),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 6, 137),
                        fontWeight: FontWeight.bold,
                      ),
                      name: "name",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Količina",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 61, 6, 137),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 6, 137),
                        fontWeight: FontWeight.bold,
                      ),
                      name: "stockQuantity",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Cijena",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 61, 6, 137),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 6, 137),
                        fontWeight: FontWeight.bold,
                      ),
                      name: "price",
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: FormBuilderDropdown<String>(
                    name: 'productTypeID',
                    initialValue: widget.product != null
                        ? widget.product?.productTypeID?.toString()
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Vrsta proizvoda',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 61, 6, 137),
                          fontWeight: FontWeight.bold,
                        ),
                        suffix: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['productTypeID']
                                ?.reset();
                          },
                        ),
                        hintText: 'Vrsta proizvoda'),
                    style: TextStyle(
                      color: Color.fromARGB(255, 61, 6, 137),
                      fontWeight: FontWeight.bold,
                    ),
                    items: productTypesResult?.result
                            .map((item) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.center,
                                  value: item.productTypeId.toString(),
                                  child: Text(item.productTypeName ?? ""),
                                ))
                            .toSet()
                            .toList() ??
                        [],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Brend",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 61, 6, 137),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 6, 137),
                        fontWeight: FontWeight.bold,
                      ),
                      name: "brand",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Opis",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 61, 6, 137),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 6, 137),
                        fontWeight: FontWeight.bold,
                      ),
                      name: "description",
                    ),
                  ),
                ],
              ),
              FormBuilderTextField(
                name: 'productPhoto',
                initialValue: _initialValue['productPhoto'],
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(height: 0),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          color: Colors.grey[200],
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_base64Image != null)
                                Image.memory(
                                  base64Decode(_base64Image!),
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              else if (widget.product == null)
                                Icon(Icons.photo, size: 100, color: Colors.grey)
                              else if (widget.product?.productPhoto != "")
                                imageFromBase64String(
                                    widget.product!.productPhoto!)
                              else
                                Icon(Icons.photo, size: 100, color: Colors.grey)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: FormBuilderField(
                      name: 'imageId',
                      builder: ((field) {
                        return Container(
                          child: ElevatedButton.icon(
                            onPressed: getImage,
                            icon: Icon(Icons.file_upload),
                            label: Text("Odaberi sliku"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Color(0xFF8031CC), width: 2.0),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }
}
