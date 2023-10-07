import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:katsitokatsi/AllScreens/mainscreen.dart';
import 'package:katsitokatsi/main.dart';
import '../AllWidgets/progressDialog.dart';
import 'registrationScreen.dart';


class  LoginScreen extends StatelessWidget
{
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: [
              const SizedBox(height: 35.0,),
              const  Image(image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              const SizedBox(height: 1.0,),
              const  Text("Login as a Rider",style: TextStyle(fontSize: 24.0,fontFamily:"Brand Bold"),
                textAlign: TextAlign.center,
              ),

               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Column(
                   children: [
                     const  SizedBox(height: 1.0,),
                       TextField(
                         controller: emailTextEditingController,
                       keyboardType: TextInputType.emailAddress,
                       decoration: InputDecoration(
                         labelText: "Email",
                         labelStyle: TextStyle(
                           fontSize: 14.0,
                         ),
                         hintStyle: TextStyle(
                           color: Colors.grey,
                           fontSize: 10.0,
                         ),

                       ),
                       style: TextStyle(fontSize: 14.0),
                     ),

                     const SizedBox(height: 1.0,),
                       TextField(
                         controller: passwordTextEditingController,
                       obscureText: true,
                       decoration: InputDecoration(
                         labelText: "Password",
                         labelStyle: TextStyle(
                           fontSize: 14.0,
                         ),
                         hintStyle: TextStyle(
                           color: Colors.grey,
                           fontSize: 10.0,
                         ),

                       ),
                       style: TextStyle(fontSize: 14.0),
                     ),

                     const SizedBox(height: 10.0,),
                     ElevatedButton(

                         onPressed: ()
                         {
                             if (!emailTextEditingController.text.contains("@"))
                            {
                              displayToastMessage("Invalid email address.", context);
                            }
                             else if (passwordTextEditingController.text.isEmpty)
                            {
                              displayToastMessage("Password must be provided", context);
                            }
                            else
                            {
                              loginAndAUthenticateUser(context);
                            }
                           },
                        child:   Container(
                       height: 50.0,
                       child: Center(
                         child: Text("Login",
                           style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),

                         ),
                       ),
                     ),
                         style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all(Colors.yellow),
                            //missing Text Color and shape of a button

                           ),
                         ),
                   ],
                 ),
               ),
              TextButton(onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(context,  RegistrationScreen.idScreen, (route) => false);
              },
                child: Text("No account? Register here"
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAUthenticateUser(BuildContext context) async
  {
    showDialog(context: context, barrierDismissible: false,
        builder: (BuildContext context)
        {

            return ProgressDialog( message: "Authenticating, Please wait...",);

        }

    );
    
    final User? userCredentials =
        (await _firebaseAuth.signInWithEmailAndPassword(email: emailTextEditingController.text,
            password: passwordTextEditingController.text).catchError((errMsg){
          Navigator.pop(context);
          displayToastMessage("Error$errMsg", context);
        })).user;

    if(userCredentials != null)
    {
      userRef.child(userCredentials.uid).once().then((DatabaseEvent snap){
        if(snap.snapshot.value != null)
          {

            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
            displayToastMessage("You are logged-in now .", context);
          }
        else
        {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("No record exists for this user. Please create new account", context);
        }
      });
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("Error Occured, can not be signed-in", context);
    }
  }
}

