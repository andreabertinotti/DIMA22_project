import 'dart:convert';
import 'package:http/http.dart';

class Location {
  var lat;
  var long;

  Location({
    this.lat,
    this.long,
  });

  @override
  String toString() {
    return 'Location(lat: $lat, long: $long)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();
  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  ////////////////////////////////////////////////////////////
  ///    INSERT API KEY
  ///////////////////////////////////////////////////////////////
  static final String apiKey = 'AIzaSyBH5ap5eRCgN7uwdzs3kGDsABB7A-0ulL8';

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<Location> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final location = Location();
        location.lat = result['result']['geometry']['location']['lat'];
        location.long = result['result']['geometry']['location']['lng'];
        return location;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fecth suggestions');
    }
  }
}
