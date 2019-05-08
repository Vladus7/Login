import 'package:flutter/material.dart';
import 'package:login_program/bloc/tiket_bloc.dart';
export 'package:login_program/bloc/tiket_bloc.dart';
class GoodsBlocProvider extends InheritedWidget{
  final bloc = GoodsBloc();

  GoodsBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static GoodsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GoodsBlocProvider) as GoodsBlocProvider).bloc;
  }
}