import 'package:complete_clean_app/controllers/auth_controller.dart';
import 'package:complete_clean_app/utils/show_snackBar.dart';
import 'package:complete_clean_app/views/buyers/auth/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class BuyerRegisterScreen extends StatefulWidget {

  @override
  State<BuyerRegisterScreen> createState() => _BuyerRegisterScreenState();
}

class _BuyerRegisterScreenState extends State<BuyerRegisterScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String fullName;

  late String phoneNumber;

  late String password;

  bool _isLoading = false;


  Uint8List ? _image;

  _signUpUser()async{
    setState(() {
      _isLoading = true;
    });
 if(_formKey.currentState!.validate()){
    await _authController.signUpUsers(
    email, fullName, phoneNumber, password, _image).whenComplete(() {
      setState(() {
        _formKey.currentState!.reset();
        _isLoading = false;
      });
    });

    return showSnack(
      context, 'Hoorah! Account Successfully Created');
 }else{
  setState(() {
    _isLoading = false;
  });
  return showSnack(context, 'Fields Must Not Be Empty');
 }
  }

selectGalleryImage() async {
Uint8List im =  await _authController.pickProfileImage(ImageSource.gallery);

setState(() {
  _image = im;
});
}


selectCameraImage() async {
Uint8List im =  await _authController.pickProfileImage(ImageSource.camera);

setState(() {
  _image = im;
});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Create Customer Account', 
                style: TextStyle(fontSize: 20 ),
                ),
               Stack(
                children: [
                 _image!=null? CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.blue.shade700,
                  backgroundImage: MemoryImage(_image!),
                ):CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.blue.shade700,
                  backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png'),
                ),
                Positioned(
                  right: 0,
                  top: 5,
                  child: IconButton(
                    onPressed: (){
                      selectGalleryImage();
                    }, 
                    icon: Icon(
                      CupertinoIcons.photo,              
                      ),
                    ),
                    ),
               ],
               ),
             Padding(
               padding: const EdgeInsets.all(13.0),
               child: TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Email Must Not Be EMPTY';
                  }else{
                    return null;
                  }
                },
                onChanged: (value){
                  email = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter Email',
                  ),
                  ),
             ),
                  
                      Padding(
               padding: const EdgeInsets.all(13.0),
               child: TextFormField(
                              validator: (value){
                  if(value!.isEmpty){
                    return 'Full Name Must Not Be EMPTY';
                  }else{
                    return null;
                  }
                },
                  onChanged: (value){
                  fullName = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter Full Name',
                  ),
                  ),
             ),
                  
                      Padding(
               padding: const EdgeInsets.all(13.0),
               child: TextFormField(
                              validator: (value){
                  if(value!.isEmpty){
                    return 'Phone Number Must Not Be EMPTY';
                  }else{
                    return null;
                  }
                },
                  onChanged: (value){
                  phoneNumber = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                  ),
                  ),
             ),
                  
                      Padding(
               padding: const EdgeInsets.all(13.0),
               child: TextFormField(
                obscureText: true,
                              validator: (value){
                  if(value!.isEmpty){
                    return 'Password Must Not Be EMPTY';
                  }else{
                    return null;
                  }
                },
                  onChanged: (value){
                  password = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter Password',
                  ),
                  ),
             ),
             GestureDetector(
              onTap: (){
                _signUpUser();
              },
               child: Container(
                width: MediaQuery.of(context).size.width -40, 
                height: 50, 
                decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(10),
               ),
               child: Center(
                child: _isLoading 
                ? CircularProgressIndicator(
                  color: Colors.white,
                ): Text(
                  'Register', 
                  style: TextStyle(
                  color:Colors.white, 
                  fontSize: 19, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  ),
                  )),
               ),
             ),
                  
                  
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already Have An Account?'),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return LoginScreen();
                    }));
                  },
                  child: Text('Login'),
                  ),
              ],
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}