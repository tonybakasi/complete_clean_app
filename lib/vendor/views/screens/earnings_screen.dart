

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/vendor/views/screens/vendor_inner_screen/withdrawal_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('vendors');
    final Stream<QuerySnapshot> _ordersStream = 
    FirebaseFirestore.instance.collection('orders').where('vendorId', isEqualTo: 
    FirebaseAuth.instance.currentUser!.uid)
    .snapshots();

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
              elevation: 0,
              title: Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(data['storeImage']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Hello '+ data['businessName'], 
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,),
                    ),
                  )
                ],
              ),
            ),

            body:
                StreamBuilder<QuerySnapshot>(
      stream: _ordersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        double totalOrder = 0.0;
        for(var orderItem in snapshot.data!.docs){
          totalOrder += 
          orderItem['quantity'] * orderItem['productPrice'];
        }
        return Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 38, 123, 7),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('TOTAL EARNINGS', style: TextStyle(
                            color: Colors.white, fontSize: 18, 
                            fontWeight: FontWeight.bold
                            ),
                            ),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: 
                          Text(
                           "£" + totalOrder.toStringAsFixed(2), 
                          style: TextStyle(
                            color: Colors.white, fontSize: 18, 
                            fontWeight: FontWeight.bold
                            ),
                            ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 119, 238),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('TOTAL ORDERS', style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255), fontSize: 18, 
                            fontWeight: FontWeight.bold
                            ),
                            ),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: 
                          Text(
                           snapshot.data!.docs.length.toString(),
                          style: TextStyle(
                            color: Colors.white, fontSize: 18, 
                            fontWeight: FontWeight.bold
                            ),
                            ),
                        ),
                      ],
                    ),
                  ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return WithdrawalScreen();
                    },));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width -50 ,
                    decoration: BoxDecoration(color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: 
                    Text('Withdraw',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.bold,),
                    ),
                    ),
                  ),
                ),
                
                ],
                ),
              ) 
           );
      },
    )
    );           
        }
        return Center(child: LinearProgressIndicator(color: Colors.blue.shade700,),
        );
      },
    );
}
}