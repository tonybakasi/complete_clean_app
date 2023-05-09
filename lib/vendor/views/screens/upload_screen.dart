

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/provider/product_provider.dart';
import 'package:complete_clean_app/vendor/views/screens/main_vendor_screen.dart';
import 'package:complete_clean_app/vendor/views/screens/upload_tab_screens/attributes_tab_screens.dart';
import 'package:complete_clean_app/vendor/views/screens/upload_tab_screens/general_screen.dart';
import 'package:complete_clean_app/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:complete_clean_app/vendor/views/screens/upload_tab_screens/location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';



class UploadScreen extends StatelessWidget {
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider = 
    Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(tabs: [
              Tab(child: Text('General'),),
              Tab(child: Text('Location'),),
              Tab(child: Text('Attributes'),),
              Tab(child: Text('Images'),),
            ]),
          ),
          body: TabBarView(children: [
            GeneralScreen(),
            LocationScreen(),
            AttributesTabScreen(),
            ImagesTabScreen(),
          ]),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed:() async {
                EasyLoading.show(status: 'Please Wait');
               if(_formKey.currentState!.validate()){
                final productId = Uuid().v4();
                await _firestore.collection('products').doc(productId).set({
                  'productId': productId,
                  'productName': _productProvider.productData['productName'],
                  'productPrice': _productProvider.productData['productPrice'],
                  'quantity': _productProvider.productData['quantity'],
                  'category': _productProvider.productData['category'],
                  'description': _productProvider.productData['description'],
                  'imageUrlList': _productProvider.productData['imageUrlList'],
                  'scheduleDate': _productProvider.productData['scheduleDate'],
                  'chargeCollection': _productProvider.productData['chargeCollection'],
                  'collectionCharge': _productProvider.productData['collectionCharge'],
                  'parentName': _productProvider.productData['parentName'],
                  'serviceList': _productProvider.productData['serviceList'],
                  'vendorId': FirebaseAuth.instance.currentUser!.uid,
                  'approved': false,
                }).whenComplete(() {
                  _productProvider.clearData();   
                  EasyLoading.dismiss();
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return MainVendorScreen();
                  }));
                });
               }
              }, 
              child: Text('Save'),
            ),
          ),
        ),
      ),
    );
  }
}