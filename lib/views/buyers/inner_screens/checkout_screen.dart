import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/provider/cart_provider.dart';
import 'package:complete_clean_app/views/buyers/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
     CollectionReference users = FirebaseFirestore.instance.collection('buyers');

     return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
        return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        ),
        body: ListView.builder(
        shrinkWrap: true,
        itemCount: _cartProvider.getCartItem.length,
        itemBuilder: ((context, index) {
          final cartData = _cartProvider.getCartItem.values.toList()[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SizedBox(
              height: 200, 
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(cartData.imageUrlList[0]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(cartData.productName,
                      style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                    Text(
                     '£'+ cartData.productPrice.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                      OutlinedButton(onPressed: null, child: 
                      Text(cartData.serviceList,
                      ),
                    ),
                    ],
                    ),
                  ),
                ],
              ),
              ),
            ),
          );
        })),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(13.0),
          child: InkWell(
            onTap: (){
              EasyLoading.show(status: 'Placing Order...');
              _cartProvider.getCartItem.forEach((key, item) { 
                final orderId = Uuid().v4();
                _firestore.collection('orders').doc(orderId).set({
                  'orderId':orderId,
                  'vendorId':item.vendorId,
                  'email': data ['email'],
                  'phone':data ['phoneNumber'],
                  'address':data ['address'],
                  'buyerId':data ['buyerId'],
                  'fullName':data ['fullName'],
                  'buyerImage':data ['profileImage'],
                  'productName':item.productName,
                  'productPrice':item.productPrice,
                  'productId':item.productId,
                  'productImage':item.imageUrlList,
                  'quantity':item.quantity,
                  'service':item.serviceList,
                  'scheduleDate':item.scheduleDate,
                  'orderDate': DateTime.now(),
                  'accepted': false,
                }).whenComplete(() {
                  setState(() {
                    _cartProvider.getCartItem.clear();
                  });
                  EasyLoading.dismiss();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
                    return MainScreen();
                  })));
                });
              });
            },
            child: Container(
              height: 50, 
              width: MediaQuery.of(context).size.width, 
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text('Place Order', 
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
                ) 
                ),
                ),
              ),
          ),
        ),
    );
        }
        return Center(child: CircularProgressIndicator(color: Colors.blue.shade700,),
        );
      },
    );
  }
}