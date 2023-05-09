
import 'package:complete_clean_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool ? _chargeCollection = false;
  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: Text ('Charge Collection', style: 
          TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
           ),),
          value: _chargeCollection, onChanged: (value){
          setState(() {
            _chargeCollection = value;
            _productProvider.getFormData(chargeCollection: _chargeCollection);
          });
         },
        ),
        if(_chargeCollection==true)
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            validator: ((value){
                  if(value!.isEmpty){
                    return 'Enter Collection Charge';
                  }else{
                    return null;
                  }
                }),
            onChanged: (value){
              
              _productProvider.getFormData(collectionCharge: int.parse(value));
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Collection Charge',
            ),
          ),
        )
      ],
    );
  }
}