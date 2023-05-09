import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/views/buyers/productDetail/product_detail_screen.dart';
import 'package:flutter/material.dart';

class MainProductsWidget extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot>
     _productsStream = FirebaseFirestore.instance.collection(
      'products')
      .where('approved', isEqualTo: true)
      .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something Went Wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        return Container(
          height: 200,
          child: GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 100/140), 
            itemBuilder: (context, index){
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
                        height: 190,
                        width: 190,
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
            }),
        );
      },
    );
  }
}