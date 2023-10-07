import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class Users
{
  late String id;
  late String email;
  late String name;
  late String phone;

  Users({required this.id ,required  this.email,required  this.name,required  this.phone});


  Users.fromSnapshot(DatabaseEvent dataSnapshot)
  {
     id = (dataSnapshot.snapshot.key)!;


     if(dataSnapshot.snapshot.value != null)
       {
         Map email = dataSnapshot.snapshot.value as Map;
         email['email'] = dataSnapshot.snapshot.value;

         Map name = dataSnapshot.snapshot.value as Map;
         email['name'] = dataSnapshot.snapshot.value;

         Map phone = dataSnapshot.snapshot.value as Map;
         email['phone'] = dataSnapshot.snapshot.value;

      }

     //email =  (dataSnapshot.snapshot.value == ["email"] as bool) as String;

  // name =  dataSnapshot.value["name"]!;
    // name =   (dataSnapshot.snapshot["name"]) as String;
     //phone =   (dataSnapshot.snapshot.value == ["phone"] as bool) as String;
  }


}