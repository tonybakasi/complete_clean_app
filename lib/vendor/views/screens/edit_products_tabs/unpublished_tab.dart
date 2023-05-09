import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UnPublishedTabScreen extends StatelessWidget {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorProductStream = FirebaseFirestore.instance.collection(
      'products').where('vendorId', isEqualTo: 
      FirebaseAuth.instance.currentUser!.uid)
      .where('approved', isEqualTo: false).snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
      stream: _vendorProductStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              final vendorProductData = snapshot.data!.docs[index];
            return Slidable(
              child:  Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: Image.network(vendorProductData['imageUrlList'][0]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendorProductData['productName'],
                      style: TextStyle(fontSize: 15, 
                      fontWeight: FontWeight.bold),
                      ),
                      Text(
                      "£" + vendorProductData['productPrice'].toStringAsFixed(2),
                      style: TextStyle(fontSize: 15, 
                      fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],),
            ),

  key: const ValueKey(0),

  startActionPane: ActionPane(
   
    motion: const ScrollMotion(),

    children:  [
     
      SlidableAction(
        flex: 2,
        onPressed: (context) async {
          await _firestore.collection('products')
          .doc(vendorProductData['productId'])
          .update({'approved':true,});
        },
        backgroundColor: Color.fromARGB(255, 5, 252, 5),
        foregroundColor: Colors.white,
        icon: Icons.approval_rounded,
        label: 'PUBLISH',
      ),
      SlidableAction(
        flex: 2,
        onPressed: (context) async {
          await _firestore.collection('products')
          .doc(vendorProductData['productId']).delete();
        },
        backgroundColor: Color.fromARGB(255, 239, 60, 0),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'DELETE',
      ),
    ],
  ));
          })),
        );
   })
    );
  }
}
