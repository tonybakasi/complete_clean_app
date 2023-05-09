import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic userData;

  EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  String? address; 

  @override
  void initState(){
    setState(() {
      _fullNameController.text = widget.userData['fullName'];
      _emailController.text = widget.userData['email'];
      _phoneController.text = widget.userData['phoneNumber'];
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
      elevation: 0,
      title: 
      Text('EDIT PROFILE', style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,),
      ),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Stack(children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade700,
                ),
                Positioned(
                  right: 0,
                  child: IconButton(onPressed: () {}
                ,icon: Icon(CupertinoIcons.photo_camera,))
              )],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _fullNameController,
                  decoration: 
                InputDecoration(
                  labelText: 'Full Name',
                ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                  labelText: 'Email Address',
                ),),
              ),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),),
              ),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    address = value;
                  },
                  decoration: InputDecoration(
                  labelText: 'Address',
                ),),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomSheet: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          EasyLoading.show(status: 'Please Wait...');
          await _firestore.collection('buyers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'fullName': _fullNameController.text,
            'email': _emailController.text,
            'phoneNumber': _phoneController.text,
            'address': address,
          }).whenComplete(() {
            EasyLoading.dismiss();
          });
        },
        child: Container(
          height: 40, 
          width: MediaQuery.of(context).size.width, 
        decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text('UPDATE FIELDS', style: TextStyle(color: Colors.white,
        fontSize: 20, fontWeight: FontWeight.bold,),
        ),
        ), 
        ),
      ),
    ),
  );
  }
}