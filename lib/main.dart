import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:katsitokatsi/AllScreens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'AllScreens/loginScreen.dart';
import 'AllScreens/registrationScreen.dart';
import 'DataHandler/appData.dart';
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}
DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
          title: 'Katsi-2-katsi',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute:FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : MainScreen.idScreen,
          routes:
          {
            RegistrationScreen.idScreen: (context) => RegistrationScreen(),
            LoginScreen.idScreen: (context) => LoginScreen(),
            MainScreen.idScreen: (context) => MainScreen(),
          },
          debugShowCheckedModeBanner: false
      ),
    );
  }


}





