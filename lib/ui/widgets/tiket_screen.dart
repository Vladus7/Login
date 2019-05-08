import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../bloc/tiket_bloc.dart';
import '../../bloc/login_bloc.dart';
import 'package:login_program/models/goods_model.dart';
import 'package:login_program/resources/tikets_provider.dart';
import 'package:login_program/ui/upload_tiket.dart';
import 'package:login_program/ui/account_screen.dart';
import 'package:login_program/resources/globals.dart' as globals;
import 'package:login_program/ui/share_screen.dart';

class TiketsScreen extends StatefulWidget {
  final String _emailAddress;

  TiketsScreen(this._emailAddress);

  @override
  _PeopleGoalsListState createState() {
    return _PeopleGoalsListState();
  }
}

class _PeopleGoalsListState extends State<TiketsScreen> {
  GoodsBloc _bloc;
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = GoodsBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //.withOpacity(0.93),//Color(0xffd50000).withOpacity(0.78),
      body: DefaultTabController(
        length: 7,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: Colors.grey[900].withOpacity(0.89),
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text("Ticets",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                        background: Image.asset(
                          "images/silverappbar.jpg",
                          fit: BoxFit.cover,
                        )),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AccountScreen(widget._emailAddress)));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShareScreen()));
                        },
                      ),
                    ]),
              ];
            },
            body: Container(
              alignment: Alignment(0.0, 0.0),
              child: StreamBuilder(
                stream: _bloc.othersGoodsList(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    List<OtherGoods> goodsList = _bloc.mapToList(docList: docs);
                    if (goodsList.isNotEmpty) {
                      return buildList(goodsList);
                    } else {
                      return Text("No Goals");
                    }
                  } else {
                    return Text("No Goals");
                  }
                },
              ),
            )),
      ),
    );
  }

  ListView buildList(List<OtherGoods> tiketsList) {
    if (globals.admin == true) {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: tiketsList.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                  //color: Color(0xffd50000).withOpacity(0.78),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Stack(children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 50.0),
                    decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("images/b_ticet9.jpg"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 400.0,
                    height: 130.0,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 50.0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.12), //80
                          borderRadius: BorderRadius.circular(10.0)),
                      width: 400.0,
                      height: 130.0,
                      child: Stack(children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                //left: 60.0,
                                ),
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 60.0),
                                  child: Text(tiketsList[index].title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22)),
                                )
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Row(children: <Widget>[
                                SizedBox(
                                  width: 60,
                                ),
                                Container(
                                  //margin: EdgeInsets.only(left: 45, right: 40.0),
                                  child: Text(tiketsList[index].message,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                ),
                              ])
                            ])),
                        Container(
                          margin: EdgeInsets.only(
                            left: 250.0,
                          ),
                          child: Column(children: <Widget>[
                            Row(children: <Widget>[
                              SizedBox(
                                width: 25,
                              ),
                              Column(children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.create,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadTiketScreen(
                                                    tiketsList[index].title,
                                                    tiketsList[index].message,
                                                    tiketsList[index].photo,
                                                    tiketsList[index].price,
                                                    )));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    _bloc.deleteData(tiketsList[index].title);
                                  },
                                ),
                              ]),
                            ]),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(3.0)),
                                width: 60.0,
                                height: 30.0,
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  tiketsList[index].price,
                                  style: TextStyle(color: Colors.white),
                                )),
                          ]),
                        ),
                      ])),
                ]),
                Padding(
                    padding: EdgeInsets.only(top: 12.5),
                    child: IconButton(
                      iconSize: 100,
                      color: Colors.red,
                      icon:CircleAvatar(
          backgroundImage: NetworkImage(tiketsList[index].photo),
          radius: 50,
          ),
                      onPressed: () {
                        _bloc.addGoods(
                          widget._emailAddress,
                          tiketsList[index].title,
                          tiketsList[index].price,
                          tiketsList[index].photo,
                          tiketsList[index].message,
                        );
                      },
                    ),),
              ]),
            ),
          );
        },
      );
    } else {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: tiketsList.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                  //color: Color(0xffd50000).withOpacity(0.78),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Stack(children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 50.0),
                    decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("images/b_ticet9.jpg"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 400.0,
                    height: 130.0,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 50.0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.12), //80
                          borderRadius: BorderRadius.circular(10.0)),
                      width: 400.0,
                      height: 130.0,
                      child: Stack(children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                //left: 60.0,
                                ),
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 60.0),
                                  child: Text(tiketsList[index].title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22)),
                                )
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Row(children: <Widget>[
                                SizedBox(
                                  width: 60,
                                ),
                                Container(
                                  //margin: EdgeInsets.only(left: 45, right: 40.0),
                                  child: Text(tiketsList[index].message,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                ),
                              ])
                            ])),
                        Container(
                          margin: EdgeInsets.only(
                            left: 250.0,
                          ),
                          child: Column(children: <Widget>[
                            Row(children: <Widget>[
                              SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _bloc.addGoods(
                                      widget._emailAddress,
                                      tiketsList[index].title,
                                      tiketsList[index].price,
                                      tiketsList[index].photo,
                                      tiketsList[index].message,
                                    );
                                  })
                            ]),
                            SizedBox(
                              height: 35,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(3.0)),
                                width: 60.0,
                                height: 30.0,
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  tiketsList[index].price,
                                  style: TextStyle(color: Colors.white),
                                )),
                          ]),
                        ),
                      ])),
                ]),
                Padding(
                    padding: EdgeInsets.only(top: 12.5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(tiketsList[index].photo),
                      radius: 50,
                    )),
              ]),
            ),
          );
        },
      );
    }
  }
}
