import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class ProfileDetailsScreen extends StatefulWidget {
  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String username = 'archit_1607';
  String followers = 'N/A';
  String following = 'N/A';
  String posts = 'N/A';

  @override
  void initState() {
    super.initState();
    fetchProfileDetails(username);
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

  void searchProfile() {
    setState(() {
      username = _usernameController.text;
      followers = 'N/A';
      following = 'N/A';
      posts = 'N/A';
    });
    fetchProfileDetails(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        title: Center(
          child: Text(
            "Account Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 8, // Add a subtle shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  // Profile picture and username section
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Search username',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: searchProfile,
                        child: Text('Search'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://pbs.twimg.com/profile_images/1526231349354303489/3Bg-2ZsT_400x400.jpg',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(), // Add a divider for separation
                SizedBox(height: 10),
                // Followers, Following, and Posts section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoItem('Followers', followers, Icons.people),
                    _buildInfoItem('Following', following, Icons.person),
                    _buildInfoItem('Posts', posts, Icons.post_add),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileDetailsScreen(),
    ),
  );
}
