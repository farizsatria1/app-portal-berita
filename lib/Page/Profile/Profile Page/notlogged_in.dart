import 'package:flutter/material.dart';
import '../../../widget/date_formatter.dart';
import '../../TabView/Terbaru/detail_page.dart';
import '../login_page.dart';
import '../register_page.dart';
import 'package:google_fonts/google_fonts.dart';

class NotLoggedInContent extends StatelessWidget {
  final Map<String, dynamic> listData;
  NotLoggedInContent({required this.listData});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          expandedHeight: 250.0, // Tinggi header saat diperluas
          floating: false, // Header tidak mengambang saat digulirkan
          pinned: false, // Header tetap terpaku di atas saat digulirkan
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/agam-logo.png",
                    fit: BoxFit.cover,
                    width: 70,
                    height: 90,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text("Masuk"),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum terdaftar?",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Daftar",
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
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
