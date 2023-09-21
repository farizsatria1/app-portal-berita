import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widget/date_formatter.dart';
import 'detail_page.dart';

class HomeTab extends StatefulWidget {
  final Map<String, dynamic>? listData;
  final Function getData;
  final Future<void> Function() onRefresh;

  HomeTab({
    required this.listData,
    required this.getData,
    required this.onRefresh,
  });

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> reversedListData =
        (widget.listData?['data'] as List?)?.reversed.toList() ?? [];

    if (reversedListData.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ), // atau widget lain yang sesuai
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: Colors.red,
      child: ListView.builder(
        //RefreshIndicator akan muncul jika turunan yang dapat di-scroll dapat
        // di-overscroll, yaitu jika konten yang dapat di-scroll lebih besar
        // daripada area pandangnya . Untuk memastikan bahwa RefreshIndicator
        // akan selalu muncul, meskipun konten yang dapat di-scroll sesuai dengan
        // area pandangnya, setel properti Scrollable.physics yang dapat di-scroll
        // ke AlwaysScrollableScrollPhysics :
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: reversedListData.length,
        itemBuilder: (context, index) {
          var data = reversedListData[index];
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailPage(
                      id: data['id'],
                      nama_kategori: data['nama_kategori'],
                    ),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Warna bayangan
                        spreadRadius: 0.5, // Penyebaran bayangan
                        blurRadius: 7, // Tingkat blur bayangan
                        offset: Offset(0, 1), // Posisi bayangan (x, y)
                      ),
                    ]
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)
                          ),
                          image: DecorationImage(
                            image: NetworkImage(data['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 95,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        child: ListView(
                          children: [
                            Text(
                              data['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['author'],
                                  style: GoogleFonts.lato(
                                      fontSize: 13, color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  getTimeAgo(data['created_at']),
                                  style: TextStyle(fontSize: 12, color: Colors.grey,),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
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
              hoverColor: Colors.grey,
              highlightColor: Colors.grey,
              splashColor: Colors.grey,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna bayangan
                      spreadRadius: 1, // Penyebaran bayangan
                      blurRadius: 2, // Tingkat blur bayangan
                      offset: Offset(0, 2), // Posisi bayangan (x, y)
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(data['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),

                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            data['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data['author'],
                                style: GoogleFonts.lato(
                                    fontSize: 13, color: Colors.grey,
                                ),
                              ),
                              Text(getTimeAgo(data['created_at']),
                                style: TextStyle(fontSize: 12, color: Colors.grey,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
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
