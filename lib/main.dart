import 'package:flutter/material.dart';
import 'package:flutter_buddies/ui/friends/friends_list_page.dart';
import 'package:flutter_buddies/data/models/auth.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'ui/signin/signin.dart';


class FriendsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.white,
      ),
      home: new FriendsListPage(),
    );
  }
}


void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ThemeModel _model = ThemeModel();
  final AuthModel _auth = AuthModel();

  @override
  void initState() {
    try {
      _auth.loadSettings();
    } catch (e) {
      print("Error Loading Settings: $e");
    }
    try {
      _model.init();
    } catch (e) {
      print("Error Loading Theme: $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>.value(value: _model),
          ChangeNotifierProvider<AuthModel>.value(value: _auth),
        ],
        child: Consumer<ThemeModel>(
          builder: (context, model, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: model.theme,
            home: Consumer<AuthModel>(builder: (context, model, child) {
              if (model?.user != null) return FriendsHomePage();
              return LoginPage();
            }),
            routes: <String, WidgetBuilder>{
              "/login": (BuildContext context) => LoginPage(),
              "/home": (BuildContext context) => FriendsHomePage()            
            },
          ),
        ));
  }
}
