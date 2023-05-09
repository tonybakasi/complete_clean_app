import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/views/buyers/productDetail/product_detail_screen.dart';
import 'package:flutter/material.dart';

class HomeProductWidget extends StatelessWidget {
final String categoryName;
const HomeProductWidget({super.key, required this.categoryName});


  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance.collection(
      'products').where(
      'category', 
      isEqualTo: 
      categoryName)
      .where('approved', isEqualTo: true)
      .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something Went Wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 220,
          child: ListView.separated(itemBuilder: (context, index){
            final productData = snapshot.data!.docs[index];
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ProductDetailScreen(productData: productData,);
                }));
              },
              child: Card(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(productData['imageUrlList'][0],
                        ),
                        fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        productData['productName'],
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                      '£' +  productData['productPrice'].toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }, separatorBuilder: (context, _)=>SizedBox(width: 15,), itemCount: snapshot.data!.docs.length),
        );
      },
    );
  }
}