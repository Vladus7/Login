import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goods_model.dart';
import '../utils/string.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GoodsBloc {
  final _repository = Repository();
  final _title = BehaviorSubject<String>();
  final _photo = BehaviorSubject<String>();
  final _price = BehaviorSubject<String>();
  final _goalMessage = BehaviorSubject<String>();
  final _showProgress = BehaviorSubject<bool>();

  Observable<String> get name => _title.stream.transform(_validateName);

  Observable<String> get photo => _photo.stream;

  Observable<String> get price => _price.stream.transform(_validatePrice);

  Observable<String> get goalMessage => _goalMessage.stream.transform(_validateMessage);

  Observable<bool> get showProgress => _showProgress.stream;

  Function(String) get changeName => _title.sink.add;

  Function(String) get changePhoto => _photo.sink.add;

  Function(String) get changePrice => _price.sink.add;

  Function(String) get changeGoalMessage => _goalMessage.sink.add;

  final _validateMessage = StreamTransformer<String, String>.fromHandlers(
  handleData: (goalMessage, sink) {
  if (goalMessage.length > 10) {
  sink.add(goalMessage);
  } else {
  sink.addError(StringConstant.goalValidateMessage);
  }
  });

  final _validatePrice = StreamTransformer<String, String>.fromHandlers(
  handleData: (price, sink) {
  if (price.length > 1) {
  sink.add(price);
  } else {
  sink.addError(StringConstant.priceValidateMessage);
  }
  });

  final _validateName = StreamTransformer<String, String>.fromHandlers(
  handleData: (String name, sink) {
  if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(name)) {
  sink.addError(StringConstant.nameValidateMessage);
  } else {
  sink.add(name);
  }
  });

  void submit(changePhoto) {
    _showProgress.sink.add(true);
    _repository
        .uploadGoal(_title.value, _price.value, changePhoto, _goalMessage.value)
        .then((value) {
      _showProgress.sink.add(false);
    });
  }

  void deleteData(name) {
    _repository.deleteData(name);
  }

  void deleteGoods(email, title) {
    _repository.deleteGoods(email, title);
  }

  void addGoods(email, String title, String price, String photo, String goal) {
    _repository.addGoods(email, title, price, photo, goal);
  }

  void UpdateData(String name, String description, String photo,  String price){
    _repository.UpdateData(name, description, photo,  price);
  }

  Stream<QuerySnapshot> goodsList(String email) {
    return _repository.goodsList(email);
  }


  Stream<QuerySnapshot> othersGoodsList() {
    return _repository.othersGoodsList();
  }

  //dispose all open sink
  void dispose() async {
    await _goalMessage.drain();
    _goalMessage.close();
    await _photo.drain();
    _photo.close();
    await _title.drain();
    _title.close();
    await _price.drain();
    _price.close();
    await _showProgress.drain();
    _showProgress.close();
  }

  //Convert map to goal list
  List mapToList({DocumentSnapshot doc, List<DocumentSnapshot> docList}) {
      List<OtherGoods> goalList = [];
      for (int i = 0; i < docList.length; i++) {
        OtherGoods result = OtherGoods(docList[i].data['productName'],docList[i].data['price'],docList[i].data['photoUrl'],docList[i].data['description'],);
        goalList.add(result);
      }
      return goalList;
  }

}