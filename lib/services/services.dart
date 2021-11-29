import 'package:http/http.dart' as http;

class Services {

  static Future<String> getSRTData(String path) async {
    var response = await http.get(Uri.parse(path));

    if(response.statusCode == 200) {
      return response.body;
    } else {
      return "Error";
    }
  }

}