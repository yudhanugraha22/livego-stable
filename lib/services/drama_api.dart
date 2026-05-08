import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class DramaAPI {
  static const String baseUrl = 'https://api-drama.dobda.id';
  static const String apiSecret = '22dfb2b849814054af0491ff2ee3ffe33989313d7d38e97aae659757a4cf8960';
  
  static String _generateSignature(String method, String path, String timestamp) {
    // Sama persis seperti di JavaScript: `GET:${full}:${ts}`
    String payload = '$method:$path:$timestamp';
    var key = utf8.encode(apiSecret);
    var bytes = utf8.encode(payload);
    var hmac = Hmac(sha256, key);
    var digest = hmac.convert(bytes);
    return digest.toString();
  }
  
  static Future<Map<String, dynamic>> _request(String method, String path, Map<String, String> queryParams) async {
    // Build path dengan query params (sama seperti JS: new URLSearchParams)
    String fullPath = path;
    if (queryParams.isNotEmpty) {
      String queryString = queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      fullPath = '$path?$queryString';
    }
    
    // Timestamp dalam milliseconds (sama seperti Date.now())
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Generate signature (sama persis dengan JS)
    String signature = _generateSignature(method, fullPath, timestamp);
    
    print('=== API Request ===');
    print('URL: $baseUrl$fullPath');
    print('Method: $method');
    print('Timestamp: $timestamp');
    print('Signature: $signature');
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$fullPath'),
        headers: {
          'X-Timestamp': timestamp,
          'X-Signature': signature,
        },
      ).timeout(const Duration(seconds: 30));
      
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return {'error': true, 'code': response.statusCode, 'message': response.body};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': true, 'exception': e.toString()};
    }
  }
  
  static Future<List<dynamic>> getHome(String category, String lang) async {
    try {
      final response = await _request('GET', '/api/v2/home', {
        'category_p': category, 
        'lang': lang
      });
      
      if (response.containsKey('error')) {
        print('API Error, using dummy data');
        return _getDummyData(category);
      }
      
      return response['data'] ?? [];
    } catch (e) {
      print('Exception getHome: $e');
      return _getDummyData(category);
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
  
  // Dummy data untuk testing
  static List<dynamic> _getDummyData(String category) {
    List<Map<String, dynamic>> allDramas = [
      {'id': '1', 'title': 'Menikahi Ayah Mantanku', 'cover': '', 'views': '12.5K', 'chapters': '61', 'status': 'Completed', 'platform': 'freereels'},
      {'id': '2', 'title': 'Cinta Suami Muda Takkan Padam', 'cover': '', 'views': '154.9K', 'chapters': '53', 'status': 'Completed', 'platform': 'freereels'},
      {'id': '3', 'title': 'Balas Dendam Ayah', 'cover': '', 'views': '73.9K', 'chapters': '69', 'status': 'Completed', 'platform': 'freereels'},
      {'id': '4', 'title': 'Istri Masa Depan CEO', 'cover': '', 'views': '45.2K', 'chapters': '48', 'status': 'Ongoing', 'platform': 'freereels'},
      {'id': '5', 'title': 'Jebakan Sang Taipan', 'cover': '', 'views': '23.8K', 'chapters': '32', 'status': 'Completed', 'platform': 'freereels'},
      {'id': '6', 'title': 'Hidup Berjaya Anak Terbuang', 'cover': '', 'views': '89.1K', 'chapters': '78', 'status': 'Completed', 'platform': 'freereels'},
      {'id': '7', 'title': 'Drama Melolo - Cinta Terlarang', 'cover': '', 'views': '34.5K', 'chapters': '45', 'status': 'Ongoing', 'platform': 'melolo'},
      {'id': '8', 'title': 'Drama Melolo - Rahasia Hati', 'cover': '', 'views': '28.9K', 'chapters': '38', 'status': 'Completed', 'platform': 'melolo'},
    ];
    
    if (category == 'freereels') {
      return allDramas.where((d) => d['platform'] == 'freereels').toList();
    } else {
      return allDramas.where((d) => d['platform'] == 'melolo').toList();
    }
  }
}
