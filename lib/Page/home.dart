import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  late TabController TabC = TabController(length: 2, vsync: this);

  List<dynamic> ListData = [];

  Future<void> GetData() async {
    String url = "http://127.0.0.1:8000/api/posts";
    try {
      var response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));
      setState(() {
        ListData = jsonDecode(response.body);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Agam News",
          style: GoogleFonts.libreBaskerville(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
        ),
        bottom: TabBar(
          indicatorWeight: 3,
          indicatorColor: Colors.red,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          controller: TabC,
          tabs: [
            Tab(
              child: Text(
                "Home",
                style: GoogleFonts.creteRound(fontSize: 13),
              ),
            ),
            Tab(
              child: Text(
                "Kategori",
                style: GoogleFonts.creteRound(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: TabC,
        children: [],
      ),
    );
  }
}
