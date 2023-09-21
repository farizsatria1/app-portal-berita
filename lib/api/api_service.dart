import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  //API untuk halaman Home
  static Future<Map<String, dynamic>> getData() async {
    String url = "https://faris-poltekpadang.pkl-lauwba.com/api/posts";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
      return {};
    } catch (e) {
      print("Error: ${e.toString()}");
      return {};
    }
  }

  //API untuk halaman DetailPage
  static Future<Map<String, dynamic>> getDetailBerita(int id) async {
    String url = "https://faris-poltekpadang.pkl-lauwba.com/api/posts/$id";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["data"];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //API untuk list Kategori
  static Future<Map<String, dynamic>> getListKategori() async {
    String url = "https://faris-poltekpadang.pkl-lauwba.com/api/kategori";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
      return {};
    } catch (e) {
      print("Error: ${e.toString()}");
      return {};
    }
  }

  //API untuk halaman Kategori
  static Future<Map<String, dynamic>> getKategori(int id) async {
    String url = "https://faris-poltekpadang.pkl-lauwba.com/api/kategori/$id";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body)["data"];
        return {"data": dataList};
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //API untuk cari berita
  static Future<List<Map<String, dynamic>>> cariBerita(String kataKunci) async {
    try {
      final response = await http.get(
        Uri.parse('https://faris-poltekpadang.pkl-lauwba.com/api/search?kata_kunci=$kataKunci'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Gagal melakukan pencarian berita');
      }
    } catch (e) {
      print('Exception: $e');
      throw e; // Lebih baik dilempar ke pemanggil untuk penanganan lebih lanjut.
    }
  }

  //API untuk register

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final String apiUrl = 'https://faris-poltekpadang.pkl-lauwba.com/api/daftar';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error response: ${response.body}');
        throw Exception('Gagal melakukan pendaftaran.'); // Pengecualian jika server mengembalikan status selain 200
      }
    } catch (e) {
      print('Exception: $e'); // Cetak pesan pengecualian untuk debugging
      throw Exception('Terjadi kesalahan saat melakukan pendaftaran.'); // Pengecualian jika ada kesalahan lain selama proses
    }
  }
}



