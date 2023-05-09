import 'package:complete_clean_app/provider/cart_provider.dart';
import 'package:complete_clean_app/utils/show_snackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
String formatedDate(date){
  final outPutDateFormat = DateFormat('dd/MM/yyyy');
  final outPutDate = outPutDateFormat.format(date);
  return outPutDate;
}

  int _imageIndex = 0;
  String? _selectedService;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text( 
        widget.productData['productName'],
        ),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: PhotoView(imageProvider: 
                  NetworkImage(widget.productData['imageUrlList'][_imageIndex])),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                  height: 50, 
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productData['imageUrlList'].length,
                    itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          _imageIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.shade700,)
                          ),
                          height: 60,
                          width: 60,
                          child: Image.network(
                            widget.productData['imageUrlList'][index]
                          ),
                        ),
                      ),
                    );
                  }),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
           '£' +  widget.productData['productPrice'].toStringAsFixed(2),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
             SizedBox(height: 20),
            Text(
              widget.productData['productName'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold
            ),
            ),
            ExpansionTile(title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product Description'),
                Text('View More'),
              ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.productData['description'],
                  style: TextStyle(fontSize: 15,
                  ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Collection Available On', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    ),
                  ),
                  Text(formatedDate(widget.productData['scheduleDate'].toDate()
                  ),
                  style: TextStyle(fontSize: 15, 
                  fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            ExpansionTile(
            title: Text('Choose Service',),
            children: [
              SingleChildScrollView(
                child: Container(height: 50,
                child: ListView.builder(
                  itemCount: widget.productData['serviceList'].length,
                  itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                     color: _selectedService == widget.productData['serviceList'][index]? 
                     Colors.blue.shade700:null,
                      child: OutlinedButton(onPressed: (){
                        setState(() {
                          _selectedService = widget.productData['serviceList'][index];        
                        });
                        print(_selectedService);
                      }, 
                      child: Text(widget.productData['serviceList'][index])
                      ),
                    ),
                  );
                }
                ),
                          ),
                          ),
              ),
            ],
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: _cartProvider.getCartItem.containsKey(widget.productData['productId'])
          ? null: (){
            if(_selectedService==null){
              return showSnack(context, 'Select a Service to Add to Cart!');
            }else{
              _cartProvider.addProductToCart(
            widget.productData['productName'], 
            widget.productData['productId'], 
            widget.productData['imageUrlList'], 
            1,
            widget.productData['quantity'],
            widget.productData['productPrice'], 
            widget.productData['vendorId'], 
            _selectedService!, 
            widget.productData['scheduleDate']);

            return showSnack(context, 'Added ${widget.productData['productName']} To Cart');
            }
          },
          child: Container(height: 50, width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(10.0),
          ),
        
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.shopping_cart,
                color: _cartProvider.getCartItem.containsKey(widget.productData['productId'])? 
                Color.fromARGB(255, 67, 66, 66) 
                :
                Colors.white,
                ),
              ),
             _cartProvider.getCartItem.containsKey(widget.productData['productId'])? 
             Text('Added To Cart ✅', style: 
              TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              ),
              ):
                Text('Add To Cart', style: 
              TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              ),
              ), 
            ],)
          ),
        ),
      ),
    );
  }
}