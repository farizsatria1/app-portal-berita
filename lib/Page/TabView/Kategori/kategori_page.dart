import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_berita/Page/TabView/Terbaru/detail_page.dart';
import '../../../api/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widget/date_formatter.dart';

class KategoriPage extends StatefulWidget {
  final int id;
  final String nama_kategori;
  final Future<void> Function() onRefresh;

  KategoriPage(
      {required this.id, required this.nama_kategori, required this.onRefresh});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  Future<Map<String, dynamic>?>? futureData;

  Future<Map<String, dynamic>?> getDataKategori() async {
    try {
      final data = await ApiService.getKategori(widget.id);
      return data;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = getDataKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nama_kategori,
            style: GoogleFonts.libreBaskerville(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light),
      ),
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
        color: Colors.red,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.data == null) {
              return Center(
                child: Text("Data is null"),
              );
            } else {
              final Map<String, dynamic> data = snapshot.data!;
              final List<dynamic> listData = data['data'];

              return ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  final reversedIndex =
                      listData.length - 1 - index; // Menghitung indeks terbalik
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            id: listData[reversedIndex]['id'],
                            nama_kategori: listData[reversedIndex]
                                ['nama_kategori'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                  listData[reversedIndex]['image'] ?? '',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),

                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  listData[reversedIndex]['title'] ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      listData[reversedIndex]['author'] ?? "",
                                      style: GoogleFonts.lato(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                    Text(
                                      getTimeAgo(listData[reversedIndex]
                                              ['created_at'] ?? ""),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
