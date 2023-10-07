
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:katsitokatsi/Assistant/requestAssistant.dart';
import 'package:katsitokatsi/configMaps.dart';
import 'package:katsitokatsi/Models/address.dart';
import 'package:katsitokatsi/DataHandler/appData.dart';
import 'package:provider/provider.dart';

import '../Models/allUsers.dart';
import '../Models/directionDetails.dart';

class AssistantMethods
{
    static Future<String> searchCoOrdinateAddress(Position position,context)async
  {
    String placeAddress =  "";
    String st1,st2,st3,st4;

    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng= ${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);
  if(response != "failed")
    {
    //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];//province0
      st2 = response["results"][0]["address_components"][1]["long_name"];//country1
      st3 = response["results"][0]["address_components"][3]["long_name"];//province3
      st4 = response["results"][0]["address_components"][4]["long_name"];//country4

      //placeAddress = response["results"][0]["address_components"][5]["long_name"];

    //st4 = response["results"][0]["address_components"][6]["long_name"];

    placeAddress = st1 + "," + st2+ "," + st3+ "," + st4  ;

    // ignore: unnecessary_new
     Address userPickUpAddress = new Address(  placeName: placeAddress, latitude: position.latitude, longitude: position.longitude);
     Provider.of<AppData>(context,listen:false).updatePickUpLocationAddress(userPickUpAddress);
  }

    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    var res  = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed")
    {
       return null;
    }

    DirectionDetails directionDetails = DirectionDetails(
        distanceValue: res["routes"][0]["legs"][0]["distance"]["value"],
        durationValue: res["routes"][0]["legs"][0]["duration"]["value"],
        distanceText:  res["routes"][0]["legs"][0]["distance"]["text"],
        durationText:  res["routes"][0]["legs"][0]["duration"]["text"],
        encodedPoints: res["routes"][0]["overview_polyline"]["points"]
    );


    return directionDetails;

  }
  static int calculateFares(DirectionDetails directionDetails)
  {
    //in USD
    double timeTraveledFare = ( directionDetails.durationValue/60) * 0.20;
    double distanceTravedFare = (directionDetails.durationValue/1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTravedFare;

    //1$ = R18  local currency
      double totalLocalAmount =  totalFareAmount * 18;

      return totalLocalAmount.truncate();

  }
   static void getCurrentOnlineUserInfo() async
   {
     firebaseUser = await FirebaseAuth.instance.currentUser;
     String userId = firebaseUser!.uid;
     DatabaseReference reference = FirebaseDatabase.instance.ref().child("users").child(userId);
     reference.once().then((DatabaseEvent databaseEvent) {
       if (databaseEvent.snapshot.value != null) {
         userCurrentInfo = Users.fromSnapshot(databaseEvent);
       }
     });
   }

     static double createRandomNumber(int num)
     {

       var random = Random();
       int randNumber = random.nextInt(num);
       return randNumber.toDouble();
     }
}
