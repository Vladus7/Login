import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _firestoreAuth = FirebaseAuth.instance;

  Future<int> authenticateUser(String email, String password) async {
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    if (docs.length == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<void> registerUser(String email, String password) async {
    _firestore
        .collection("users")
        .document(email)
        .setData({'email': email, 'password': password, 'isAdmin': false,
      'name' : 'Please enter Name',
      'photo': 'https://firebasestorage.googleapis.com/v0/b/massive-current-230014.appspot.com/o/person.jpg?alt=media&token=e6375cac-8cc0-4ccb-8fe1-d76610f7a939',});
  }

  Future<void> registerUserWithGoogle(String email, String password, String name, String photo) async {
    _firestore
        .collection("users")
        .document(email)
        .setData({'email': email,
      'password': password,
      'isAdmin': false,
      'name' : name,
      'photo': photo,});
  }

  Future<void> registerUserWithFacebook(String email, String password, String name, String photo) async {
    _firestore
        .collection("users")
        .document(name)
        .setData({'email': 'Please enter Email',
      'password': password,
      'isAdmin': false,
      'name' : name,
      'photo': photo,});
  }

  Future<int> signIn(String email, String password) async {
    _firestoreAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<int> registerAuthUser(String email, String password) async {
    _firestoreAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  addData(String title, String price, String photo, String description) async{
    Firestore.instance.collection('tickets').document(title).setData({'productName': title, 'description': description, 'photoUrl': photo,'price': price});
  }

  addGoods(email, String title, String price, String photo, String description) async{
    Firestore.instance.collection('purchases').document(email).collection('goods').document(title).setData({'productName': title, 'description': description, 'photoUrl': photo,'price': price});
  }

  deleteData(name) async{
    Firestore.instance.collection('tickets').document(name).delete();
  }

  deleteGoods(email, title) async{
    Firestore.instance.collection('purchases').document(email).collection('goods').document(title).delete();
  }

  UpdateData(name, description, photo,  price) async{
    Firestore.instance.collection('tickets').document(name).setData({'productName': name, 'description': description, 'photoUrl': photo,'price': price});
  }

  UpdateUser(email, isAdmin, name, password ,photo) async{
    Firestore.instance.collection('users').document(email).setData({'email':email,'isAdmin':isAdmin, 'name':name, 'password':password, 'photo':photo});
  }

  UpdateUserFacebook(email, isAdmin, name, password ,photo) async{
    Firestore.instance.collection('users').document(name).setData({'email':email,'isAdmin':isAdmin, 'name':name, 'password':password, 'photo':photo});
  }



  Stream<DocumentSnapshot> accountUser(name) {
    final user = _firestore.collection("users").document(name).snapshots();
    print(user);
    return user;
  }

  Stream<QuerySnapshot> goodsList(email) {
    return _firestore.collection('purchases').document(email).collection('goods').snapshots();
  }

  Stream<QuerySnapshot> othersGoodsList() {
    return _firestore
        .collection("tickets")
        .snapshots();
  }

}
