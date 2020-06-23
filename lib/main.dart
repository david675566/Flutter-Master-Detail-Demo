import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Master Detail Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MasterPage(),
    );
  }
}

class MasterPage extends StatefulWidget {
  MasterPageState createState() => MasterPageState();
}

class MasterPageState extends State<MasterPage> {
  String selectedItem;

  Widget pageBuilder(){
    return FutureBuilder(
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.none && snapshot.hasData == null){
          return Container();
        }

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              return ListTile(
                selected: snapshot.data[index] == selectedItem,
                title: Text(snapshot.data[index]),
                onTap: (){
                  setState(() {
                    selectedItem = snapshot.data[index];

                    while (Navigator.of(context).canPop()){
                      Navigator.of(context).pop();
                    }

                    Navigator.of(context).push(
                        DetailRoute(builder: (context){
                          return DetailPage(item: selectedItem);
                        })
                    );
                  });
                },
              );
            },
        );
      },
      future: getJsonFile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Master Detail Demo")
      ),
      body: pageBuilder()
    );
  }

  Future getJsonFile() async {
     String data = await DefaultAssetBundle.of(context).loadString('assets/poems-cipai.json');
     return jsonDecode(data);
  }
}

class DetailRoute<T> extends TransitionRoute<T> with LocalHistoryRoute<T> {
  DetailRoute({@required WidgetBuilder this.builder, RouteSettings settings}) : super (settings: settings);

  final WidgetBuilder builder;

  Iterable<OverlayEntry> createOverlayEntries(){
    return [
      OverlayEntry (builder: (context) {
        return Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: builder(context)
          )
        );
      })
    ];
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 250);
}

class DetailPage extends StatelessWidget {
  DetailPage({Key key, @required this.item}) : super (key: key);

  final String item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: BackButton(color: Colors.white,)
      ),

      body: Container(
        child: Center(
          child: Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text("Detail Page: ${item}")
            ),
          ),
        ),
      ),
    );
  }
}