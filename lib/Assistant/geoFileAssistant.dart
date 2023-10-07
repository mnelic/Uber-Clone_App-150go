import '../Models/nearbyAvailableDrivers.dart';

class GeoFireAssisant
{


  static List<NearbyAvailableDrivers> nearByAvailavleDriverslist = [];

  static void removeDriverFromlist( String key)
  {

     int index = nearByAvailavleDriverslist.indexWhere((element) => element.key == key);
     nearByAvailavleDriverslist.removeAt(index);
  }
  static void updateDrivernearbylocation(NearbyAvailableDrivers driver )
  {

    int index = nearByAvailavleDriverslist.indexWhere((element) => element.key == driver.key);
    nearByAvailavleDriverslist[index].latitude = driver.latitude;
    nearByAvailavleDriverslist[index].longitude = driver.longitude;
  }





}