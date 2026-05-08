import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class DramaAPI {
  static const String baseUrl = 'https://api-drama.dobda.id';
  static const String apiSecret = '22dfb2b849814054af0491ff2ee3ffe33989313d7d38e97aae659757a4cf8960';
  
  static String _generateSignature(String method, String path, String timestamp) {
    String payload = '$method:$path:$timestamp';
    var key = utf8.encode(apiSecret);
    var hmac = Hmac(sha256, key);
    var digest = hmac.convert(utf8.encode(payload));
    return digest.toString();
  }
  
  static Future<Map<String, dynamic>> _request(String method, String path, Map<String, String> queryParams) async {
    String fullPath = path;
    if (queryParams.isNotEmpty) {
      String queryString = queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      fullPath = '$path?$queryString';
    }
    
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String signature = _generateSignature(method, fullPath, timestamp);
    
    final response = await http.get(
      Uri.parse('$baseUrl$fullPath'),
      headers: {
        'X-Timestamp': timestamp,
        'X-Signature': signature,
      },
    );
    
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': true, 'code': response.statusCode, 'body': response.body};
    }
  }
  
  static Future<List<dynamic>> getHome(String category, String lang) async {
    try {
      final response = await _request('GET', '/api/v2/home', {
        'category_p': category, 
        'lang': lang
      });
      if (response.containsKey('error')) {
        print('API Error: ${response['code']}');
        // Data dummy untuk testing
        return _getDummyData();
      }
      return response['data'] ?? [];
    } catch (e) {
      print('Exception: $e');
      return _getDummyData();
    }
  }
  
  static Future<List<dynamic>> search(String category, String query, String lang, {int page = 1}) async {
    try {
      final response = await _request('GET', '/api/v2/search', {
        'category_p': category, 
        'q': query, 
        'lang': lang, 
        'page': page.toString()
      });
      if (response.containsKey('error')) {
        return [];
      }
      return response['data'] ?? [];
    } catch (e) {
      return [];
    }
  }
  
  // Dummy data untuk testing (kalau API error)
  static List<dynamic> _getDummyData() {
    return [
      {'id': '1', 'title': 'Menikahi Ayah Mantanku', 'cover': '', 'views': '12.5K', 'chapters': '61', 'status': 'Completed'},
      {'id': '2', 'title': 'Cinta Suami Muda', 'cover': '', 'views': '154.9K', 'chapters': '53', 'status': 'Completed'},
      {'id': '3', 'title': 'Balas Dendam Ayah', 'cover': '', 'views': '73.9K', 'chapters': '69', 'status': 'Completed'},
      {'id': '4', 'title': 'Istri Masa Depan CEO', 'cover': '', 'views': '45.2K', 'chapters': '48', 'status': 'Ongoing'},
      {'id': '5', 'title': 'Jebakan Sang Taipan', 'cover': '', 'views': '23.8K', 'chapters': '32', 'status': 'Completed'},
      {'id': '6', 'title': 'Hidup Berjaya Anak Terbuang', 'cover': '', 'views': '89.1K', 'chapters': '78', 'status': 'Completed'},
    ];
  }
}
