import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:katsitokatsi/AllScreens/mainscreen.dart';
import 'package:katsitokatsi/main.dart';
import '../AllWidgets/progressDialog.dart';
import 'loginScreen.dart';


class  RegistrationScreen extends StatelessWidget
{
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
              const  Text("Register as a Rider",style: TextStyle(fontSize: 24.0,fontFamily:"Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const  SizedBox(height: 1.0,),
                       TextField(
                      controller:  nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name & Surname",
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

                    const  SizedBox(height: 1.0,),
                      TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Contact Number",
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

                      onPressed: () {
                         if(nameTextEditingController.text.length < 3)
                           {
                              displayToastMessage("Name must be at least 3 characters.", context);
                           }
                         else  if (!emailTextEditingController.text.contains("@"))
                         {
                           displayToastMessage("Invalid email address.", context);
                         }
                         else  if (phoneTextEditingController.text.isEmpty )
                         {
                           displayToastMessage("Phone number is mandatory and must have 10 digits", context);
                         }
                         else  if (passwordTextEditingController.text.length < 6)
                         {
                           displayToastMessage("Password must be at least 6 characters", context);
                         }
                         else
                         {
                           registerNewUser(context);
                         }

                        },
                      child:   Container(
                        height: 50.0,
                        child: Center(
                          child: Text("Create Account",
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
                Navigator.pushNamedAndRemoveUntil(context,  LoginScreen.idScreen, (route) => false);
              },
                child: Text("Already have an account? Login here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser( BuildContext context) async
  {

      showDialog(context: context, barrierDismissible: false,
      builder: (BuildContext context)
      {

        return ProgressDialog( message: "Registering, Please wait...",);

      }
         );

    final User? userCredentials =
    (await _firebaseAuth.createUserWithEmailAndPassword
      (email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
          displayToastMessage("Error$errMsg", context);
    })).user;

   if(userCredentials != null)
     {

        Map userDataMap = {
          "name":nameTextEditingController.text.trim(),
          "email":emailTextEditingController.text.trim(),
          "phone":phoneTextEditingController.text.trim(),

        };
        userRef.child(userCredentials.uid).set(userDataMap);
        displayToastMessage("Congratulations, your account has been created.", context);
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
     }
   else
   {
     Navigator.pop(context);
     displayToastMessage("New user account has not been created", context);
   }
  }
}

displayToastMessage( String message, BuildContext context)
{

  Fluttertoast.showToast(msg: message );
}

