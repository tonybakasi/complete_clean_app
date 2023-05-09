
import 'package:flutter/widgets.dart';

class ProductProvider with ChangeNotifier{
 Map<String, dynamic> productData = {};

 getFormData({
  String? productName, 
  double? productPrice, 
  int? quantity, 
  String ? category, 
  String? description,
  DateTime ? scheduleDate, 
  List<String>? imageUrlList,
  bool? chargeCollection, 
  int? collectionCharge,
  String? parentName,
  List<String>? serviceList
  }) {
  if (productName!=null){
    productData['productName'] = productName;
  }

  if(productPrice!=null){
    productData['productPrice'] = productPrice;
  }

  if(quantity!=null){
    productData['quantity'] = quantity;
  }

  if(category!=null){
    productData['category'] = category; 
  }

  if(description!=null){
    productData['description'] = description;
  }
  if(scheduleDate!=null){
    productData['scheduleDate'] = scheduleDate;
  }
  if(imageUrlList!=null){
    productData['imageUrlList'] = imageUrlList;
  }
  if(chargeCollection != null){
    productData['chargeCollection'] = chargeCollection;
  }
  if(chargeCollection != null){
    productData['chargeCollection'] = chargeCollection;
  }
  if(collectionCharge != null){
    productData['collectionCharge'] = collectionCharge;
  }
   if(parentName != null){
    productData['parentName'] = parentName;
  }
  if(serviceList != null){
    productData['serviceList'] = serviceList;
  }

  notifyListeners();
 }

 clearData(){
  productData.clear();
  notifyListeners();
 }
}