

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class BuyersOrderScreen extends StatelessWidget {
  
String formatedDate(date){
  final outPutDateFormat = DateFormat('dd/MM/yyyy');

  final outPutDate = outPutDateFormat.format(date);

  return outPutDate;
}

  @override
  Widget build(BuildContext context) {
     
     final Stream<QuerySnapshot> _ordersStream = 
     FirebaseFirestore.instance.collection('orders')
     .where('buyerId', isEqualTo: 
     FirebaseAuth.instance.currentUser!.uid)
     .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'My Orders',
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
  
            return Column(
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
            );
          }).toList(),
        );
      },
    )
    );
}
}