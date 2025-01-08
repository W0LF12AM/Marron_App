import 'package:cloud_firestore/cloud_firestore.dart';  
import 'package:firebase_auth/firebase_auth.dart';  
  
Future<String> getUserName() async {  
  User? user = FirebaseAuth.instance.currentUser;  
  if (user != null) {  
    DocumentSnapshot<Map<String, dynamic>> snapshot =  
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();  
  
    if (snapshot.exists) {  
      Map<String, dynamic>? data = snapshot.data();  
      return data?['name'] ?? 'User'; 
    }  
  }  
  return 'User'; 
}  
