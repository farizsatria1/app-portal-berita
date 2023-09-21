import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widget/date_formatter.dart';
import '../../TabView/Terbaru/detail_page.dart';
import '../../home.dart';

class LoggedInContent extends StatelessWidget {
  final Map<String, dynamic> listData;
  final SharedPreferences prefs;

  LoggedInContent({required this.listData, required this.prefs});

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          expandedHeight: 300.0, // Tinggi header saat diperluas
          floating: true, // Header tidak mengambang saat digulirkan
          pinned: false, // Header tetap terpaku di atas saat digulirkan
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/agam-logo.png",
                    // Ganti dengan URL gambar profil pengguna
                    fit: BoxFit.cover,
                    width: 70,
                    height: 90,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Selamat Datang Kembali",
                    // Menampilkan nama pengguna dari SharedPreferences
                    style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${prefs.getString('name')}",
                    // Menampilkan nama pengguna dari SharedPreferences
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${prefs.getString('email')}",
                    // Menampilkan email pengguna dari SharedPreferences
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Tombol logout
                  ElevatedButton(
                    child: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Konfirmasi LogOut",
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            content: Text(
                              "Apakah Anda Yakin ingin Log Out?",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Batal",
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  prefs.remove("id");
                                  prefs.remove("name");
                                  prefs.remove("email");
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => Home(),
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Anda Sudah Log Out',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Log Out",
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        TerbaruHeader(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              final reversedIndex = listData['data'].length - 1 - index;
              var data = listData['data'][reversedIndex];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        id: data['id'],
                        nama_kategori: data['nama_kategori'],
                      ),
                    ),
                  );
                },
                child: Container(
                  child: ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    title: Text(
                      data['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      getTimeAgo(data['created_at']),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
            childCount: listData['data'] != null ? listData['data'].length : 0,
          ),
        ),
      ],
    );
  }
}


//Untuk membuat agar Kata Terbaru tetap di atas saat digulir

class TerbaruHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true, // Header akan tetap melekat di atas
      floating: false,
      delegate: _TerbaruHeaderDelegate(),
    );
  }
}

class _TerbaruHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 50.0; // Tinggi header saat minimized
  @override
  double get maxExtent => 50.0; // Tinggi header saat expanded

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "Pemberitahuan",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10,),
          Divider(
            thickness: 2,
            indent: 20,
            endIndent: 20,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TerbaruHeaderDelegate oldDelegate) {
    return false; //mempertahankan header ini saat digulir
  }
}
