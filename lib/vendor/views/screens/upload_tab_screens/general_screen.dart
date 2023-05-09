
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_clean_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GeneralScreen extends StatefulWidget {
  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> 
with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categoryList = [];

_getCategories(){
  return _firestore
  .collection('categories')
  .get()
  .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) { 
      setState(() {
        _categoryList.add(doc['categoryName']);
      });
    });
  });
}

@override
  void initState() {
    _getCategories();
    super.initState();
  }

  String formatedDate(date){
    final outPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormat.format(date);
    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = 
    Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: ((value){
                  if(value!.isEmpty){
                    return 'Enter Product';
                  }else{
                    return null;
                  }
                }),
                onChanged: (value){
                  _productProvider.getFormData(productName: value);
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product',
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                validator: ((value){
                  if(value!.isEmpty){
                    return 'Enter Price';
                  }else{
                    return null;
                  }
                }),
                onChanged: (value){
                  _productProvider.getFormData(productPrice: double.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Enter Price',
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                validator: ((value){
                  if(value!.isEmpty){
                    return 'Enter Quantity';
                  }else{
                    return null;
                  }
                }),
                onChanged: (value){
                  _productProvider.getFormData(quantity: int.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Enter Quantity',
                ),
              ),
               SizedBox(height: 12,),
              DropdownButtonFormField(
                hint: Text('Select Category'),
                items: _categoryList.map<DropdownMenuItem<String>>((e){
                return DropdownMenuItem(
                  value: e,
                  child: Text(e));
              }).toList(), 
              onChanged: (value){
                setState(() {
                  _productProvider.getFormData(category: value);   
                });
              }),
              SizedBox(height: 6,),
              TextFormField(
                validator: ((value){
                  if(value!.isEmpty){
                    return 'Enter Description';
                  }else{
                    return null;
                  }
                }),
                onChanged: (value){
                  _productProvider.getFormData(description: value);
                },
                minLines: 3,
                maxLines: 10,
                maxLength: 560,
                decoration: InputDecoration(
                  labelText: 'Enter Description', 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                  ),
              ),
              Row(children: [
                TextButton(onPressed: (){
                  showDatePicker(context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime.now(), 
                  lastDate: DateTime(2100)).then((value) {
                    setState(() {
                      _productProvider.getFormData(scheduleDate: value);
                    });     
                  });
                }, 
                child: Text('Collection'),
                ),
               if(_productProvider.productData['scheduleDate']!=null)
               Text(formatedDate(_productProvider.productData['scheduleDate'],
                ),
                ),
              ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}