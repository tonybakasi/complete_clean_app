import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/models/cart_attributes.dart';
import 'package:flutter/widgets.dart';

class CartProvider with ChangeNotifier{
  Map<String, CartAttributes> _cartItems = {};

  Map<String, CartAttributes> get getCartItem{
  
  return _cartItems;

  }

double get totalPrice{
  var total = 0.00;


  _cartItems.forEach((key, value) {

  total +=  value.productPrice * value.quantity;
  });

  return total;
}
void addProductToCart(
  String productName,
  String productId,
  List imageUrlList,
  int quantity,
  int vendorQuantity,
  double productPrice,
  String vendorId,
  String serviceList,
  Timestamp scheduleDate,
  ){
    if(_cartItems.containsKey(productId)){
      _cartItems.update(productId, 
      (existingCart) => CartAttributes(
        productName: existingCart.productName, 
        productId: existingCart.productId, 
        imageUrlList: existingCart.imageUrlList, 
        quantity: existingCart.quantity + 1,
        vendorQuantity: existingCart.quantity , 
        productPrice: existingCart.productPrice, 
        vendorId: existingCart.vendorId, 
        serviceList: existingCart.serviceList, 
        scheduleDate: existingCart.scheduleDate));

        notifyListeners();
    }else{
      _cartItems.putIfAbsent(productId, () => CartAttributes
      (productName: productName, 
      productId: productId, 
      imageUrlList: imageUrlList, 
      quantity: quantity,
      vendorQuantity: vendorQuantity, 
      productPrice: productPrice, 
      vendorId: vendorId, 
      serviceList: serviceList, 
      scheduleDate: scheduleDate));

      notifyListeners();
    }
  }
  void increment(CartAttributes cartAttributes){
cartAttributes.increase();
notifyListeners();
}
void decrement(CartAttributes cartAttributes){
cartAttributes.decrease();
notifyListeners();
}

removeItem(productId){
  _cartItems.remove(productId);

  notifyListeners();
}

removeAllItems(){
  _cartItems.clear();

  notifyListeners();
}
}