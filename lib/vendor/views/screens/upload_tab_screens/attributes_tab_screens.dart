
import 'package:complete_clean_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttributesTabScreen extends StatefulWidget {
  @override
  State<AttributesTabScreen> createState() => _AttributesTabScreenState();
}

class _AttributesTabScreenState extends State<AttributesTabScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
final TextEditingController _serviceController = TextEditingController();
bool _entered = false;

List<String> _serviceList = [];

bool _isSave = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
            validator: ((value){
                  if(value!.isEmpty){
                    return 'Enter Parent';
                  }else{
                    return null;
                  }
                }),
            onChanged: (value){
              _productProvider.getFormData(parentName: value);
            },
            decoration: InputDecoration(
              labelText: 'Parent',
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  width: 250,
                  child: TextFormField(
                    controller: _serviceController,
                    onChanged: (value){
                      setState(() {
                        _entered = true;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Service',
                    ),
                  ),
                ),
              ),
               _entered ==true? ElevatedButton(
                onPressed: (){
                  setState(() {
                    _serviceList.add(_serviceController.text);
                    _serviceController.clear();
                  });
                  print(_serviceList);
                }, 
                child: 
              Text(
                'Add',
              ),
            )
            : Text(''),
            ],
          ),
      if(_serviceList.isNotEmpty)
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _serviceList.length,
            itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _serviceList.removeAt(index);
                        _productProvider.getFormData(serviceList: _serviceList);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                      ),
                      child: Text(
                        _serviceList[index],
                        style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),
                );
              }),
              ),
        ),
      ),
    if(_serviceList.isNotEmpty)
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.green.shade300),
    onPressed: (){
      _productProvider.getFormData(serviceList: _serviceList);

      setState(() {
        _isSave = true;
      });
    }, 
    child: Text(
    _isSave ? 'SAVED':'save',
    style: TextStyle(fontWeight: FontWeight.bold, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}