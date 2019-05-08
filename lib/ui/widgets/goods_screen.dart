import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../bloc/tiket_bloc.dart';
import '../../models/goods_model.dart';
import 'package:login_program/resources/tikets_provider.dart';
import 'package:login_program/ui/account_screen.dart';
import 'package:login_program/ui/share_screen.dart';

class GoodsScreen extends StatefulWidget {
  final String _emailAddress;

  GoodsScreen(this._emailAddress);

  @override
  _GoodsScreenState createState() {
    return _GoodsScreenState();
  }
}

class _GoodsScreenState extends State<GoodsScreen> {
  GoodsBloc _bloc;

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
      backgroundColor: Colors.white,
      body: DefaultTabController(
          length: 7,
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      backgroundColor: Colors.white,
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text("Carts",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              )),
                          background: Image.asset(
                            "images/appBar.png",
                            fit: BoxFit.cover,
                          )),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.account_circle, color: Color(0xffd50000)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountScreen(widget._emailAddress)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Color(0xffd50000),),
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
                    stream: _bloc.goodsList(widget._emailAddress),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> docs = snapshot.data.documents;
                        List<OtherGoods> goodsList =
                            _bloc.mapToList(docList: docs);
                        if (goodsList.isNotEmpty) {
                          return buildList(goodsList);
                        } else {
                          return Text("No tikets");
                        }
                      } else {
                        return Text("No tikets");
                      }
                    },
                  )))),
      floatingActionButton: FloatingActionButton.extended(
      onPressed: showMessage,
        backgroundColor: Color(0xffd50000),
        icon: Icon(
          Icons.monetization_on,
          color: Colors.white,
        ),
        label: Text(
          'Buy',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void showMessage() {
    final snackbar = SnackBar(
        content: Text('Your order is begin processed'),
        duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  ListView buildList(List<OtherGoods> goodsList) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: goodsList.length,
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
                        image: new AssetImage("images/b_ticet6.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  width: 400.0,
                  height: 130.0,),
            Container(
              margin: EdgeInsets.only(left: 50.0),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12), //80
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
                          SizedBox(width: 20,),
                          Container(
                        margin: EdgeInsets.only(left: 60.0),
                        child: Text(goodsList[index].title,
                            style: TextStyle(color: Colors.black,fontSize: 22)),
                      )]),
                      SizedBox(height: 5,),
            Row(children: <Widget>[
              SizedBox(width: 60,),Container(
                        //margin: EdgeInsets.only(left: 45, right: 40.0),
                        child: Text(goodsList[index].message,
                            style: TextStyle(color: Colors.black,fontSize: 14)),
                      ),])
                    ])
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          left: 250.0,
                        ),
                        child: Column(children: <Widget>[
                        Row(children: <Widget>[
                          SizedBox(width: 25,),
                          IconButton(
                            icon: Icon(Icons.clear, color: Colors.black),
                            onPressed: () {
                              _bloc.deleteGoods(
                                  widget._emailAddress, goodsList[index].title);
                            },
                          ),]),
                          SizedBox(height: 35,),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(3.0)),
                              width: 60.0,
                              height: 30.0,
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                goodsList[index].price,
                                style: TextStyle(color: Colors.white),
                              )),
                        ])),
                  ])
                  ),
            ]),
              Padding(
                  padding: EdgeInsets.only(top: 12.5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(goodsList[index].photo),
                    radius: 50,
                  )),
            ]),
          ),
        );
      },
    );
  }
}
