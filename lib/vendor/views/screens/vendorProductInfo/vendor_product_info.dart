import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorProductInfo extends StatefulWidget {
  final dynamic productData;

  const VendorProductInfo({super.key, required this.productData});

  @override
  State<VendorProductInfo> createState() => _VendorProductInfoState();
}

class _VendorProductInfoState extends State<VendorProductInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();


  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _parentNameController.text = widget.productData['parentName'];
      _quantityController.text = widget.productData['quantity'].toString();
      _productPriceController.text = widget.productData['productPrice'].toString();
      _descriptionController.text = widget.productData['description'];
      _categoryNameController.text = widget.productData['category'];
    });
    super.initState();
  }

  double? productPrice;
  int? quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0,  
      title: 
      Text(widget.productData['productName'])),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name'),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _parentNameController,
              decoration: InputDecoration(
                labelText: 'Parent Name'),
        ),
            SizedBox(height: 20,),
            TextFormField(
              onChanged: (value) {
                quantity = int.parse(value);
              },
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity'),
        ),
             SizedBox(height: 20,),
            TextFormField(
              onChanged: (value) {
                productPrice = double.parse(value);
              },
              controller: _productPriceController,
              decoration: InputDecoration(
                labelText: 'Price'),
        ),
              SizedBox(height: 20,),
            TextFormField(
              maxLength: 560,
              maxLines: 3,
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description'),
        ),
        SizedBox(height: 20,),
            TextFormField(
              enabled: false,
              controller: _categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category'),
        ),
        ],
        ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () async {
            await _firestore.collection('products').doc(widget.productData['productId']).update({
              'productName': _productNameController.text,
              'parentName': _parentNameController,
              'quantity': quantity,
              'productPrice': productPrice,
              'description': _descriptionController.text,
              'category': _categoryNameController.text,
            });
          },
          child: Container(
          height: 40, width:
          MediaQuery.of(context).size.width, 
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(10,
            ),
            ),
            child: Center(child: Text("Update Products", style:
            TextStyle(fontSize: 20, color: Colors.white, 
            fontWeight: FontWeight.bold,
            ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}