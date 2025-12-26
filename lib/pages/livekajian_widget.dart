import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LiveKajianWidget extends StatefulWidget {
  @override
  _LiveKajianWidgetState createState() => _LiveKajianWidgetState();
}

class _LiveKajianWidgetState extends State<LiveKajianWidget> {
  final String apiKey = "isiapikeydisini"; // API Key YoutubeData v3 dari google cloud platform
  final List<String> channelIds = [
    "UC5KW9VowHehb_jHAhDMZpEQ", // Channel ID Ustadz 1
    "UClvc6c04-xEYKFFyeP3yjKA", // Channel ID Ustadz 2
    "UCN2ySyRgxARVmENnOZ70rbg", // Channel ID Ustadz 3
    "UC_KYVOU2lpXpuSsQ5JI6xvg", // Channel ID Ustadz 4
  ];

  List<Map<String, dynamic>> liveVideos = [];

  @override
  void initState() {
    super.initState();
    fetchLiveStreams();
  }

  Future<void> fetchLiveStreams() async {
    List<Map<String, dynamic>> tempLiveVideos = [];

    for (String channelId in channelIds) {
      final url =
          "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&eventType=live&type=video&key=$apiKey";

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data["items"].isNotEmpty) {
            tempLiveVideos.add({
              "snippet": data["items"][0]["snippet"],
              "videoId": data["items"][0]["id"]["videoId"],
            });
          }
        } else {
          print("Failed to fetch live stream: ${response.body}");
        }
      } catch (e) {
        print("Error fetching live stream for channel $channelId: $e");
      }
    }

    setState(() {
      liveVideos = tempLiveVideos;
    });
  }

  String _buildThumbnailUrl(String videoId) {
    // Fallback URL sesuai prioritas
    return "https://i.ytimg.com/vi/$videoId/hqdefault_live.jpg";
  }

  @override
  Widget build(BuildContext context) {
    return liveVideos.isNotEmpty
        ? Column(
            children: liveVideos.map((video) {
              final videoId = video["videoId"];
              final title = video["snippet"]["title"] ?? "Judul tidak tersedia";
              final description = video["snippet"]["description"] ?? "Deskripsi tidak tersedia";
              final channelTitle = video["snippet"]["channelTitle"] ?? "Channel tidak diketahui";

              // URL thumbnail dari videoId
              final thumbnailUrl = _buildThumbnailUrl(videoId);

              return GestureDetector(
                onTap: () {
                  final url = "https://www.youtube.com/watch?v=$videoId";
                  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                },
                child: Card(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        thumbnailUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          description,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          channelTitle,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : Center(
            child: Text(
              "Tidak ada kajian live saat ini",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
  }
}
