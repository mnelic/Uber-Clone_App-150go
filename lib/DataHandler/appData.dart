import 'package:flutter/cupertino.dart';
import 'package:katsitokatsi/Models/address.dart';
class AppData extends ChangeNotifier
{
   Address?  pickUplocation , dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    pickUplocation = pickUpAddress;
    notifyListeners();
  }

   void updateDropOffLocationAddress(Address dropOffAddress)
   {
     dropOffLocation = dropOffAddress;
     notifyListeners();
   }

}
