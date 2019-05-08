import 'dart:async';
import '../utils/string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:login_program/resources/globals.dart' as globals;

class LoginBloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  Observable<String> get email => _email.stream.transform(_validateEmail);

  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  Observable<bool> get signInStatus => _isSignedIn.stream;

  String get emailAddress => _email.value;

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
  if (email.contains('@')) {
  sink.add(email);
  } else {
  sink.addError(StringConstant.emailValidateMessage);
  }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
  handleData: (password, sink) {
  if (password.length > 3) {
  sink.add(password);
  } else {
  sink.addError(StringConstant.passwordValidateMessage);
  }
  });

  Future<int> submit() {
    return _repository.authenticateUser(_email.value, _password.value);
  }

  Future<int> signIn(){
    globals.loginName = _email.value;
    globals.isLogin = true;
    return _repository.signIn(_email.value, _password.value);
  }
  Future<void> registerUser() {
    return _repository.registerUser(_email.value, _password.value);
  }
  Future<int> registerAuthUser() {
    return _repository.registerAuthUser(_email.value, _password.value);
  }

  Future<void> UpdateUser(email, isAdmin, name, password ,photo){
    return _repository.UpdateUser(email, isAdmin, name, password ,photo);
  }

  Future<void> UpdateUserFacebook(email, isAdmin, name, password ,photo){
    return _repository.UpdateUserFacebook(email, isAdmin, name, password ,photo);
  }

  Future<void> registerUserWithGoogle(String email, String password, String name, String photo){
    return _repository.registerUserWithGoogle(email, password, name, photo);
  }

  Future<void> registerUserWithFacebook(String email, String password, String name, String photo){
    return _repository.registerUserWithFacebook(email, password, name, photo);
  }

  Stream<DocumentSnapshot> accountUser(String email) {
    final user = _repository.accountUser(email);
    print(user);
    return user;//_repository.accountUser(email);
  }

  List mapToList({DocumentSnapshot doc, List<DocumentSnapshot> docList}) {
    List<User> userList = [];
    for (int i = 0; i < doc.data.length; i++) {
      User result = User(doc.data['email'],doc.data['password'],doc.data['isAdmin'],doc.data['name'],doc.data['photo'],);
     // if (docList[i].data['email'] == emailAddress){
      userList.add(result);
    //  print(result);}
    }
    return userList;
  }

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 3) {
      return true;
    } else {
      return false;
    }
  }
}