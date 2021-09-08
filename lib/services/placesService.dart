import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);
}

class Place {
  String streetNumber;
  String street;
  String city;
  String zipCode;

  Place({
    this.streetNumber = '',
    this.street = '',
    this.city = '',
    this.zipCode = '',
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class PlacesService {
  final client = Client();
  String sessionToken = '';

  // PlacesService();

  static final String androidKey = 'AIzaSyA7dFeS3Jlo3UUpehEoqgpSjbo76ZeG7J8';
  static final String iOsKey = '';
  final apiKey = Platform.isAndroid ? androidKey : iOsKey;

  setSessiontToken(String newSessionToken) {
    sessionToken = newSessionToken;
  }

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:gh&key=$apiKey&sessiontoken=$sessionToken';

    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  // Future<Place> getPlaceDetailFromId(String placeId) async {
  //   // if you want to get the details of the selected place by place_id
  // }
}
