import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portal_berita/Page/TabView/Kategori/kategori_page.dart';

class KategoriTab extends StatefulWidget {
  final Map<String, dynamic> listData;
  final Function getData;

  KategoriTab({required this.listData, required this.getData});

  @override
  _KategoriTabState createState() => _KategoriTabState();
}

class _KategoriTabState extends State<KategoriTab> {
  Future<void> _refreshData() async {
    // Implement your data refresh logic here
    await widget.getData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.listData.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        : RefreshIndicator(
            onRefresh: _refreshData,
            color: Colors.red,
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.red));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    itemCount: widget.listData['data'].length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => KategoriPage(
                                id: widget.listData['data'][index]['id'],
                                nama_kategori: widget.listData['data'][index]
                                    ['nama_kategori'],
                                onRefresh: _refreshData,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.listData['data']
                                          [index]['image_kategori'] ??
                                      ""),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.listData['data'][index]
                                              ['nama_kategori'] ??
                                          "",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          );
  }
}
