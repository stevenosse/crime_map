import 'dart:convert';

import 'package:crime_map/models/place_response.dart';
import 'package:crime_map/utils/constants.dart';
import 'package:dio/dio.dart';

class MapsService {
  Dio _dio;
  MapsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://api.mapbox.com",
      ),
    );
  }

  Future<PlaceResponse> getPlaces(String pattern) async {
    try {
      Response response = await _dio.get(
          "/geocoding/v5/mapbox.places/$pattern.json?access_token=${Constants.mapboxApiKey}");
      print(response.data);
      return PlaceResponse.fromJson(jsonDecode(response.data));
    } catch (e) {
      throw new Exception("Couldn't retrieve data.");
    }
  }
}

final MapsService mapsService = MapsService();
