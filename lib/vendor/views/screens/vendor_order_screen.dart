

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class VendorOrderScreen extends StatelessWidget {
  
String formatedDate(date){
  final outPutDateFormat = DateFormat('dd/MM/yyyy');

  final outPutDate = outPutDateFormat.format(date);

  return outPutDate;
}


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
     
     final Stream<QuerySnapshot> _ordersStream = 
     FirebaseFirestore.instance.collection('orders')
     .where('vendorId', isEqualTo: 
     FirebaseAuth.instance.currentUser!.uid)
     .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Store Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20),
          ),
          ),

          body: StreamBuilder<QuerySnapshot>(
      stream: _ordersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator
          (color: Colors.blue.shade700),);
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
  
            return Slidable(
              child:  
            Column(
              children: [
                ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 14,
                  child:document['accepted']==true?Icon
                  (Icons.check_box):
                  Icon(Icons.timer)
                ),

                title: document['accepted'] ==true
                ? Text('Completed', style: TextStyle(
                  color: Color.fromARGB(255, 37, 163, 43),
                  fontWeight: FontWeight.bold),)
                :Text('Order Processing', style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,),
                ),
                trailing: Text(
                  "£" + document['productPrice'].toStringAsFixed(2),
                  style: TextStyle(fontSize: 15),
                  ),
                  subtitle: Text(formatedDate(document['orderDate'].toDate(),
                  ), style: TextStyle( fontWeight: FontWeight.bold)),
                ),

                ExpansionTile(title: Text('Order Detail',
                style: TextStyle(color: Colors.blue.shade700,
                fontSize: 15
                ),
                ),
                subtitle: Text('View Order Details'),

                children: [
                  ListTile(
                    leading: CircleAvatar(child: Image.network(document['productImage'][0]
                    ),
                    ),
                     title: Text(document['productName']),
                     subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(('Quantity'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold),
                              ),
                              Text(document['quantity'].toString(),
                              ),
                          ],
                        ),
                        document['accepted'] == true?
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          Text('Collection Date'),
                          Text(formatedDate(document['scheduleDate'].toDate()))
                      ],
                     )
                    :Text(''),

                    ListTile(title: Text('Buyer Details', style: TextStyle(
                      fontSize: 18,
                    ),
                    ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document['fullName']),
                      Text(document['email']),
                      Text(document['address']),
                    ],
                  )
                    )
                ]),
                  ),
                ],
                ),
              ],
            ),

  startActionPane: ActionPane(

    motion: const ScrollMotion(),

    children:  [
      SlidableAction(
        onPressed: (context) async {
          await _firestore.collection('orders')
          .doc(document['orderId']).update({
            'accepted':false,
          });
        },
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Reject',
      ),
      SlidableAction(
        onPressed: (context)async{ 
          await _firestore.collection('orders')
          .doc(document['orderId']).update({
            'accepted':true,
          });},
        backgroundColor: Color(0xFF21B7CA),
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: 'Accept',
      ),
    ],
  ));
          }).toList(),
        );
      },
    )
    );
}
}