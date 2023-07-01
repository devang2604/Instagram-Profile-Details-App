import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class ProfileDetailsScreen extends StatefulWidget {
  final String username;

  ProfileDetailsScreen({required this.username});

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  String followers = 'N/A';
  String following = 'N/A';
  String posts = 'N/A';

  @override
  void initState() {
    super.initState();
    fetchProfileDetails(widget.username);
  }

  Future<void> fetchProfileDetails(String username) async {
    try {
      final response =
          await http.get(Uri.parse('https://www.instagram.com/$username'));

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final metaTags = document.getElementsByTagName('meta');

        for (var tag in metaTags) {
          final propertyAttribute = tag.attributes['property'];
          if (propertyAttribute == 'og:description') {
            final contentAttribute = tag.attributes['content'];
            final counts = contentAttribute?.split(' ') ?? [];
            if (counts.length >= 4) {
              setState(() {
                followers = counts[0];
                following = counts[2];
                posts = counts[4];
              });
              break;
            }
          }
        }
      } else {
        throw Exception('Failed to fetch profile details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Username: ${widget.username}',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Followers: $followers',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Following: $following',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Posts: $posts',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ProfileDetailsScreen(
        username:
            'virat.kohli', // Just change the username here and run the program again, it will give you the approx results.
      ),
    ),
  );
}
