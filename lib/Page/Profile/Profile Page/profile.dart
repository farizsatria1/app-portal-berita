import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/api_service.dart';
import 'logged_In.dart';
import 'notlogged_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> listData = {};
  bool isLoggedIn = false; // Melacak status login
  late SharedPreferences prefs;

  Future<void> checkLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getInt('id') !=
          null; // Periksa apakah 'id' ada dalam SharedPreferences
    });
  }

  Future<void> getData() async {
    final data = await ApiService.getData();
    setState(() {
      listData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Periksa status login saat halaman dimuat
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.libreBaskerville(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body:
          isLoggedIn // Gunakan flag isLoggedIn untuk merender konten secara bersyarat
              ? LoggedInContent(listData: listData, prefs: prefs,)
              : NotLoggedInContent(listData: listData,),
    );
  }
}
