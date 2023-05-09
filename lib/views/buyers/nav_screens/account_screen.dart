import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/views/buyers/auth/login_screen.dart';
import 'package:complete_clean_app/views/buyers/inner_screens/edit_profile.dart';
import 'package:complete_clean_app/views/buyers/inner_screens/orders_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return _auth.currentUser ==null ? Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'PROFILE', style: TextStyle(letterSpacing: 2),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Icon(CupertinoIcons.moon),
            ),
          ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 2,
            ),
            Center(
              child: CircleAvatar(
                radius: 50, 
                backgroundColor: Colors.blue.shade700,
                child: Icon(Icons.person),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Text(
              'Log in to Access Profile',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
              ),
                    ),
            ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text( 
              '',
              style: TextStyle(
                fontSize: 17, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder:((context) {
                return LoginScreen();
              }) ));
            },
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width -200,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Center(child: Text('LOG IN TO ACCOUNT', 
              style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              ),
              ),
              )
            ),
          ),
        ],
        ),
      ),
    ): 
    
    FutureBuilder<DocumentSnapshot>(
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
        elevation: 1,
        title: Text(
          'PROFILE', style: TextStyle(letterSpacing: 2),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Icon(CupertinoIcons.moon),
            ),
          ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2,
            ),
            Center(
              child: CircleAvatar(
                radius: 50, 
                backgroundColor: Colors.blue.shade700,
                backgroundImage: NetworkImage(data['profileImage']),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Text(
              data['fullName'],
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
              ),
                    ),
            ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text( 
              data['email'],
              style: TextStyle(
                fontSize: 17, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context){
                return EditProfileScreen(userData: data,);
              }));
            },
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width -200,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Center(child: Text('EDIT PROFILE', 
              style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              ),
              ),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Divider(
              thickness: 1, 
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone Number'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone Number'),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return BuyersOrderScreen();
              }));
            },
            leading: Icon(Icons.shopping_bag_rounded),
            title: Text('Orders'),
          ),
          ListTile(
            onTap: () async {
              await _auth.signOut().whenComplete(() => {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LoginScreen();
                }))
              });
            },
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
          ),
          ],
        ),
      ),
    );
  }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}