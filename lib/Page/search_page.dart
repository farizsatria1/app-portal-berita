import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portal_berita/Page/TabView/Terbaru/detail_page.dart';

import '../api/api_service.dart';
import '../widget/date_formatter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController cari = TextEditingController();
  List<Map<String, dynamic>>? beritaList; // BeritaList menjadi nullable
  bool isSearching = false; // Menambahkan status pencarian
  bool isNotFound = false; // Menambahkan status pencarian tidak ditemukan

  Future<void> cariBerita(String kataKunci) async {
    try {
      setState(() {
        isSearching = true;
        isNotFound = false;
      });
      final result = await ApiService.cariBerita(kataKunci);
      setState(() {
        beritaList = result;
        isSearching = false;
        isNotFound = beritaList!.isEmpty;
      });
    } catch (e) {
      print('Exception: $e');
      // Handle exception, misalnya menampilkan pesan kesalahan pada pengguna.
    }
  }

  @override
  void initState() {
    super.initState();
    beritaList = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade100,
          ),
          child: TextFormField(
            cursorWidth: 2,
            autofocus: true,
            cursorColor: Colors.red,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) {
              setState(() {
                isSearching = true; // Aktifkan indikator loading
                isNotFound =
                    false; // Setel status pencarian tidak ditemukan ke false
              });
              cariBerita(cari.text);
            },
            controller: cari,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = true; // Aktifkan indikator loading
                    isNotFound =
                    false; // Setel status pencarian tidak ditemukan ke false
                  });
                  cariBerita(cari.text);
              }, icon: Icon(Icons.search,color: Colors.red),),
              hintText: "Search",
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          if (isSearching) // Tampilkan loading jika sedang mencari
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            )
          else if (beritaList != null) // Tampilkan hasil pencarian jika ada
            Expanded(
              child: isNotFound
                  ? Center(child: Text('Berita tidak ditemukan'))
                  : ListView.builder(
                      itemCount: beritaList!.length,
                      itemBuilder: (context, index) {
                        final berita = beritaList![index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailPage(
                                    id: berita['id'],
                                    nama_kategori: berita['nama_kategori'],
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
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
                                        berita['image'] ?? '',
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
                                        berita['title'] ?? 'Judul tidak tersedia',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10,),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(berita['author'] ??
                                                'Penulis tidak tersedia',
                                            style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            getTimeAgo(berita['created_at']) ??
                                                'Tanggal tidak tersedia',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                            ),
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
                    ),
            )
          else // Tampilkan pesan pencarian awal di sini
            Expanded(
              child: Center(
                child: Text('Silakan masukkan judul berita'),
              ),
            ),
        ],
      ),
    );
  }
}
