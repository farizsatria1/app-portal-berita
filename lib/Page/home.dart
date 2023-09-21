import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portal_berita/Page/TabView/Terbaru/tabview_home.dart';
import 'package:portal_berita/Page/TabView/Kategori/tabview_kategori.dart';
import 'package:portal_berita/Page/TabView/Video/tabview_video.dart';
import 'package:portal_berita/Page/search_page.dart';
import '../api/api_service.dart';
import 'Profile/Profile Page/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> listData = {};

  Future<void> getData() async {
    final data = await ApiService.getData();
    setState(() {
      listData = data;
    });
  }

  Map<String, dynamic> listKategori = {};

  Future<void> getListKategori() async {
    final data = await ApiService.getListKategori();
    setState(() {
      listKategori = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getListKategori();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Agam",
            style: GoogleFonts.libreBaskerville(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  "Terbaru",
                  style: GoogleFonts.creteRound(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  "Kategori",
                  style: GoogleFonts.creteRound(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  "Video",
                  style: GoogleFonts.creteRound(fontSize: 14),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage(),));
                  },
                  icon: Icon(Icons.search),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(),));
                  },
                  icon: Icon(Icons.person),
                  color: Colors.black,
                ),
              ],
            )
          ],
        ),
        body: TabBarView(
          children: [
            HomeTab(listData: listData, getData: getData,onRefresh: getData),
            KategoriTab(listData: listKategori, getData: getListKategori),
            VideoPage(),
          ],
        ),
      ),
    );
  }
}


