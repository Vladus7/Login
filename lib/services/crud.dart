import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class crudMedthods{
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(ticketData ) async{
    if (isLoggedIn()) {
      Firestore.instance.collection('tickets').document(ticketData['productName'])
          .setData(ticketData);
     // Firestore.instance.collection('tickets').add(ticketData);
          //.catchError((e) {print(e);}
     // );
    } else {
      print('You need to be logged in');
    }
  }

  UpdateData(ticketData) async{
    Firestore.instance.collection('tickets').document(ticketData['productName']).updateData(ticketData);
  }

  DelateData(ticketData) async{
    Firestore.instance.collection('tickets').document(ticketData['productName']).delete();
  }

  getDataTickets() async {
    return await Firestore.instance.collection('tickets').getDocuments();
  }

  Future<void> addUserData(Data) async{
    if (isLoggedIn()) {
      Firestore.instance.collection('users').document(Data['email'])
          .setData(Data);
    } else {
      print('You need to be logged in');
    }
  }

  UpdateUserData(Data) async{
    Firestore.instance.collection('users').document(Data['email']).updateData(Data);
  }

  DelateUserData(Data) async{
    Firestore.instance.collection('users').document(Data['email']).delete();
  }

  getDataUser() async {
    return await Firestore.instance.collection('users').getDocuments();
  }

  Future<void> addGoods(GoodsData, name ) async{
    if (isLoggedIn()) {
      Firestore.instance.collection('purchases').document(name).collection('goods').document(GoodsData['productName']).setData(GoodsData);
    } else {
      print('You need to be logged in');
    }
  }

  getDataGoods(name) async {
    return await Firestore.instance.collection('purchases').document(name).collection('goods').getDocuments();
  }

  DelateGoods(name, productName) async{
    Firestore.instance.collection('purchases').document(name).collection('goods').document(productName).delete();
  }
}
