import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImgBBService {
  final String apiKey = "2fda240954d51a02401140595a5e8900"; // Replace with your API key
  final String uploadUrl = "https://api.imgbb.com/1/upload";

  /// Upload image using File
  Future<Map<String, dynamic>?> uploadImageFile(File imageFile, {int? expiration}) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));

      request.fields['key'] = apiKey;
      if (expiration != null) {
        request.fields['expiration'] = expiration.toString();
      }

      request.files.add(await http.MultipartFile.fromPath("image", imageFile.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        print("Error: ${response.statusCode} -> $responseBody");
        return null;
      }
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }

  /// Upload image using Base64 string
  Future<Map<String, dynamic>?> uploadImageBase64(String base64Image, {int? expiration}) async {
    try {
      var uri = Uri.parse(uploadUrl);

      var body = {
        "key": apiKey,
        "image": base64Image,
        if (expiration != null) "expiration": expiration.toString(),
      };

      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} -> ${response.body}");
        return null;
      }
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }
}
