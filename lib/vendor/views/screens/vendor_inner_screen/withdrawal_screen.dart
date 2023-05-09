import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WithdrawalScreen extends StatelessWidget {

late String amount;

late String name;

late String bankName;

late String sortCode;

late String accountNumber;

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Withdraw', style: TextStyle(color: Colors.white
        ,fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 15,),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return 'Withdrawal Sum Must Not Be EMPTY';
                    }else{
                      return null;
                    }
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Withdrawal Amount',
                  ),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Name Must Not Be EMPTY';
                    }else{
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                 SizedBox(height: 15,),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return 'Bank Name Must Not Be EMPTY';
                    }else{
                      return null;
                    }
                  },
                   onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                  ),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return 'Sort-Code Must Not Be EMPTY';
                    }else{
                      return null;
                    }
                  },
                   onChanged: (value) {
                    sortCode = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Bank Sort-Code Number',
                  ),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return 'Account Number Must Not Be EMPTY';
                    }else{
                      return null;
                    }
                  },
                   onChanged: (value) {
                    accountNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Bank Account Number',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if(_formkey.currentState!.validate()){
                        
                        await _firestore
                        .collection('withdrawal')
                        .doc(Uuid().v4())
                        .set({
                          'Withdrawal Amount': amount,
                          'Name': name,
                          'Bank Name': bankName,
                          'Bank Sort-Code Number': sortCode,
                          'Bank Account Number': accountNumber,
                        });
                      print('withdrawn');
                    }else{
                      print('failed');
                    }
                  }, 
                  child: Text('WITHDRAW NOW',
                style: TextStyle
                (color: Color.fromARGB(255, 21, 124, 27)),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}