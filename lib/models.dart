import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'secret/secret.dart' as secret;

final String host = "api.discogs.com";
final String resource = "/users/${secret.username}/collection";
final String token = secret.token;

final Map<String, String> headers = {
  "Authorization": "Discogs token=${secret.token}"
};

Future<List<Release>> fetchAllReleases() async {
  var result = [];

  Future<List<Release>> f1 = fetchReleases("1");
  Future<List<Release>> f2 = fetchReleases("2");
  Future<List<Release>> f3 = fetchReleases("3");
  Future<List<Release>> f4 = fetchReleases("4");
  var futures = await Future.wait<List<Release>>([f1, f2, f3, f4]);

  result = futures[0] + futures[1] + futures[2] + futures[3];

  return result;
}

Future<List<Release>> fetchReleases(String page) async {
  final Map<String, dynamic> qp = {"per_page": "100", "page": page};

  var url = Uri.https(host, resource, qp);

  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    return Release.fromList(convert.jsonDecode(response.body));
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return null;
}

class Release {
  final String artist;
  final String title;
  final int id;

  Release({this.artist, this.title, this.id});

  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
        artist: json['basic_information']['artists'][0]['name'],
        title: json['basic_information']['title'],
        id: json['basic_information']['id']);
  }

  static List<Release> fromList(Map<String, dynamic> json) {
    List<Release> result = [];
    List<dynamic> releases = json["releases"];
    releases.forEach((element) {
      result.add(Release.fromJson(element));
    });
    return result;
  }

  static String hasNext(Map<String, dynamic> json) {
    if (json['pagination']['urls']['next'] != null) {
      print("got next.. ");
      return json['pagination']['urls']['next'];
    }
    return null;
  }
}
