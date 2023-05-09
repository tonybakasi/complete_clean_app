import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


_uploadProfileImageToStorage(Uint8List? image) async {
Reference ref = 
_storage.ref().child('profilePics').child(_auth.currentUser!.uid);
UploadTask uploadTask = ref.putData(image!);

TaskSnapshot snapshot = await uploadTask;
String downloadUrl = await snapshot.ref.getDownloadURL();

return downloadUrl;

}

pickProfileImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

XFile? _file =  await _imagePicker.pickImage(source: source);

if(_file!=null){
  return await _file.readAsBytes();
}else{
  print('No Image Selected');
}
}

  Future<String> signUpUsers(
    String email, String fullName, String phoneNumber, 
    String password, Uint8List? image) async {
 String  res = 'Somer error occured';


 try {
   if(email.isNotEmpty && 
      fullName.isNotEmpty && 
      phoneNumber.isNotEmpty && 
      password.isNotEmpty && image !=null){

   UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);

    String profileImageUrl = await _uploadProfileImageToStorage(image);


    await _firestore.collection('buyers').doc(cred.user!.uid).set({
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'buyerId': cred.user!.uid,
      'address':'',
      'profileImage': profileImageUrl,
    });

    res = 'success';
   }else{
    res = 'Fields Must Not Be EMPTY';
   }
 } catch (e) {}
  
  return res;
  } 


    loginUsers(String email, String password) async {

    String  res = 'Something Went Wrong';

    try {
      if(email.isNotEmpty && password.isNotEmpty){
          await _auth.signInWithEmailAndPassword(
            email: email, password: password);

            res = 'Success!';
      }else{
        res = 'Fields Must Not Be EMPTY';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
    }
}