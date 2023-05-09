import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CartAttributes with ChangeNotifier{

final String productName;

final String productId;

final List imageUrlList;

int quantity;

int vendorQuantity;

final double productPrice; 

final String vendorId;

final String serviceList;

Timestamp scheduleDate;

  CartAttributes({
    required this.productName, 
    required this.productId, 
    required this.imageUrlList, 
    required this.quantity,
    required this.vendorQuantity, 
    required this.productPrice, 
    required this.vendorId, 
    required this.serviceList,
    required this.scheduleDate});


    void increase(){
      quantity++;
    }

    void decrease(){
      quantity--;
    }
}