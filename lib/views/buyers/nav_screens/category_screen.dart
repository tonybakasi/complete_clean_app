

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/views/buyers/inner_screens/all_products_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('categories').snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        title: Text('Categories',
        style: TextStyle(
          fontWeight: FontWeight.bold
          ),
        ),
      ),
      
      body: StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.blue.shade700),);
        }
        return Container(
          height: 300,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
            final categoryData = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return AllProductScreen(categoryData: categoryData,);
                  }));
                  },
                leading: Image.network(categoryData['image']),
                title: Text(categoryData['categoryName'],
                ),
              ),
            );
          }),
        );
      },
    ) );
  }
}