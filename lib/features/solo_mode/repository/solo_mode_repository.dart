import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class SoloModeRepository {
  static Future<List<String>> fetchParagraph(String mode) async {
    var client = http.Client();
    try{
      var response = await client.get(Uri.parse('https://darktype.onrender.com/api/v1/text'), headers: {
        "difficulty": mode
      });

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<String> textList = List<String>.from(jsonData['data']['text']);
      log(jsonData.toString());
      return textList;
    } catch(e) {
      log(e.toString());
      return [];
    }
  }
}