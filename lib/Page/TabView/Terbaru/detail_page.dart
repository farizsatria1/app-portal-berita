import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:portal_berita/Page/Profile/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_service.dart';
import '../../../widget/date_formatter.dart';
import '../../Profile/Profile Page/logged_In.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String nama_kategori;

  DetailPage({required this.id, required this.nama_kategori});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<Map<String, dynamic>>? detailBerita;
  Future<List<dynamic>>? commentsFuture;
  List<dynamic> comments = [];
  TextEditingController commentController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    detailBerita = ApiService.getDetailBerita(widget.id);
    SharedPreferences.getInstance().then((sharedPrefs) {
      prefs = sharedPrefs;
    });
    commentsFuture = fetchComments();
  }

  Future<List<dynamic>> fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://faris-poltekpadang.pkl-lauwba.com/api/komen/${widget.id}'), // Menggunakan widget.id untuk mengambil komentar berdasarkan ID berita
      );

      if (response.statusCode == 200) {
        final List<dynamic> comments = jsonDecode(response.body);
        return comments;
      } else {
        throw Exception('Failed to load comments - ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      throw Exception('Failed to load comments');
    }
  }

  Future<void> sendComment() async {
    try {
      final String commentText = commentController.text;
      final String name = prefs.getString('name') ?? "";
      final String email = prefs.getString('email') ?? "";

      if (commentText.isNotEmpty) {
        final newComment = {
          'name': name,
          'email': email,
          'comment': commentText,
          'berita_id': widget.id,
        };

        final response = await http.post(
          Uri.parse('https://faris-poltekpadang.pkl-lauwba.com/api/komen'),
          body: jsonEncode(newComment),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          // Tambahkan komentar baru ke daftar komentar
          comments.insert(0, newComment);
          commentController.clear();

          // Memperbarui tampilan komentar dengan memicu setState pada FutureBuilder
          setState(() {
            commentsFuture = fetchComments();
          });
        } else {
          print('Failed to send comment - ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error sending comment: $e');
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nama_kategori,
          style: GoogleFonts.libreBaskerville(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: detailBerita,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            final detailBerita = snapshot.data;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      detailBerita!["image"] != null
                          ? detailBerita["image"]
                          : "Loading",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                    SizedBox(height: 15,),

                    Text(
                      detailBerita["title"] ?? "",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              detailBerita["author"] ?? "",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            Text(" - Agam",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(detailBerita["created_at"] ?? "",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),

                    Text(
                      detailBerita["content"] ?? "",
                      style:
                          GoogleFonts.lora(fontSize: 14, color: Colors.black,),
                    ),
                    SizedBox(height: 30,),

                    // Daftar Komentar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Komentar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10,),

                        // Textfield untuk komentar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),

                            TextFormField(
                              maxLines: 3,
                              cursorColor: Colors.red,
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: "Tulis komentar Anda",
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  // Sesuaikan warna ini sesuai keinginan Anda.
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                if (LoggedInContent == true) {
                                  sendComment();
                                } else {
                                  // Tampilkan pemberitahuan bahwa pengguna harus login
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Anda harus Log In terlebih dahulu',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      action: SnackBarAction(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ));
                                        },
                                        label: 'Log in',textColor: Colors.black,
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                              child: Text("Kirim Komentar"),
                            ),
                            SizedBox(height: 40,),

                          ],
                        ),
                        // List komentar
                        FutureBuilder<List<dynamic>>(
                          future: commentsFuture,
                          builder: (context, commentSnapshot) {
                            if (commentSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                heightFactor: 1,
                                child: CircularProgressIndicator(
                                    color: Colors.red),);
                            } else {
                              final commentList = commentSnapshot.data;

                              // Membalik urutan komentar menggunakan List.reversed
                              final reversedCommentList =
                                  commentList!.reversed.toList();

                              // Render daftar komentar dengan ListView.builder
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: reversedCommentList.length,
                                itemBuilder: (context, index) {
                                  final comment = reversedCommentList[index];
                                  return Column(
                                    children: [
                                      Card(
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: ListTile(
                                            title: Text(
                                              comment['name'] ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(comment['email'] ?? ""),
                                                Text(
                                                  getTimeAgo(comment[
                                                          'created_at']) ?? "",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(height: 15,),

                                                Text(
                                                  comment['comment'] ?? "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
