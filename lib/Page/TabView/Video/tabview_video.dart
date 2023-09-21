import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:portal_berita/Page/TabView/Video/fullscreen_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Map<String, dynamic>> videoData = [];

  @override
  void initState() {
    super.initState();
    fetchVideoData();
  }

  Future<void> fetchVideoData() async {
    try {
      final response =
          await http.get(Uri.parse('https://faris-poltekpadang.pkl-lauwba.com/api/videos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          videoData = data
              .map((item) => {
                    'url': item['youtube_url'] as String,
                    'title': item['title'] as String,
                  })
              .toList();
          videoData = videoData.reversed.toList();
        });
      } else {
        throw Exception('Failed to load video data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: videoData.length,
            itemBuilder: (context, index) {
              try {
                final String videoUrl = videoData[index]['url'] as String;
                final String videoId =
                    YoutubePlayer.convertUrlToId(videoUrl) ?? '';
                final YoutubePlayerController _controller =
                    YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                  ),
                );
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Warna bayangan
                        spreadRadius: 1, // Penyebaran bayangan
                        blurRadius: 2, // Tingkat blur bayangan
                        offset: Offset(0, 2), // Posisi bayangan (x, y)
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(
                            isExpanded: true,
                            colors: ProgressBarColors(
                              playedColor: Colors.redAccent,
                              handleColor: Colors.red,
                              bufferedColor: Colors.grey,
                              backgroundColor: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FullScreenVideoPage(
                                videoUrl: videoUrl,
                                videoId: videoId,
                                title: videoData[index]['title'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(
                            videoData[index]['title'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                print('Error loading video: $e');
                return SizedBox(); // Tampilkan widget kosong jika terjadi kesalahan
              }
            },
          );
        }
      }),
    );
  }
}
