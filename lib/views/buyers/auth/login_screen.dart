
import 'package:complete_clean_app/controllers/auth_controller.dart';
import 'package:complete_clean_app/utils/show_snackBar.dart';
import 'package:complete_clean_app/views/buyers/auth/register_screen.dart';
import 'package:complete_clean_app/views/buyers/main_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey <FormState> _formKey = GlobalKey <FormState>();
  final AuthController _authController = AuthController();
  late String email;
  late String password;

 bool _isLoading = false;

  _loginUsers() async{
    setState(() {
      _isLoading = true;
    });
    if(_formKey.currentState!.validate()){
   String res = await _authController.loginUsers(email, password);

   if(res=='Success!'){
    return Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (BuildContext context) {
    return MainScreen();
    }));
   }else{
    return showSnack(context, res);
   }
    }else{
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Fields Must Not Be EMPTY');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Customer Account',
              style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextFormField(
                  validator: ((value) {
                    if(value!.isEmpty){
                      return 'Email Field Must Not Be EMPTY';
                    }else{
                      return null;
                    }
                  }),
                  onChanged: ((value) {
                    email = value;
                  }),
                  decoration: InputDecoration(
                  labelText: 'Enter Email Address',
                ),
                ),
              ),
               Padding(
                 padding: const EdgeInsets.all(13.0),
                 child: TextFormField(
                  obscureText: true,
                  validator: ((value) {
                    if(value!.isEmpty){
                      return 'Password Field Must Not Be EMPTY';
                    }else{
                      return null;
                    }
                  }),
                  onChanged: ((value) {
                    password = value;
                  }),
                  decoration: InputDecoration(
                  labelText: 'Enter Password',
                           ),
                         ),
               ),
               SizedBox(
                height: 20,
                ),
               InkWell(
                onTap: () {
                  _loginUsers();
                },
                 child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(10)
                  ),
                             child: Center(
                             child: _isLoading ? 
                             CircularProgressIndicator(
                              color: Colors.white,
                              )
                              : Text(
                  'Login', 
                  style: TextStyle(
                    letterSpacing: 5, 
                    color: Colors.white, 
                    ),
                  ),
                  ),
                 ),
               ),
        
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign up an account?'),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return BuyerRegisterScreen();
                      },));
                    }, 
                    child: Text('Register',
                    ),
                    ),
                ],)
            ],
          ),
        ),
      ),
    );
  }
}