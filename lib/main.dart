import 'package:celulari/Providers/LikeProvider.dart';
import 'package:celulari/Services/SqliteService.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/AuthProvider.dart';
import 'Providers/DatabaseProvider.dart';
import 'Responsiveness/ScreenSize.dart';
import 'Screens/SplashScreen.dart';
//d51b5d5a39db53269b9a9f1b8120c34200000000

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
          create: (BuildContext context) {
            return DatabaseProvider();
          },
        ),
        ChangeNotifierProvider<SqliteService>(
          create: (BuildContext context) {
            return SqliteService();
          },
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext context) {
            return AuthProvider();
          },
        ),
        ChangeNotifierProvider<LikeProvider>(
          create: (BuildContext context) {
            return LikeProvider();
          },
        ),
      ],
      child: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        //  print(MediaQuery.of(context).size.height);
        return OrientationBuilder(
          builder: (context, orientation) {
            ScreenSize().init(constraints, orientation);
            return MaterialApp(


                debugShowCheckedModeBanner: false,
                title: 'Learning Platform Application',
                home: SplashScreen()

                //authProvider.getCurrentUser()!=null?BottomNavigation():AuthenticatioPage()

                );
          },
        );
      },
    );
  }

}
