import 'package:careergy_mobile/screens/company_profile.dart';
import 'package:careergy_mobile/screens/contact_company.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/company.dart';
import '../models/post.dart';
import 'apply_for_company_Screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _selectedCity = 'Riyadh'; // Default selected city
  List<Company> _companies = []; // Array to store all the companies
  List<Post> _posts = []; // Array to store all the posts
  List _postsIDs = [];
  List _companiesUid = [];

  Widget _buildProfileList() {
    return ListView.builder(
      itemCount: _companies.length,
      itemBuilder: (BuildContext context, int index) {
        final profile = _companies[index];
        return ListTile(
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyProfile(
                      companyName: profile.name,
                      jobs: ['jobs'],
                      bio: profile.bio,
                      image: profile.photoUrl,
                      email: profile.email,
                      phone: profile.phone,
                      uid: _companiesUid[index]),
                ),
              );
            },
            child: Card(
              color: canvasColor,
              elevation: 4,
              child: Row(
                children: [
                  SizedBox(
                      width: 64,
                      height: 64,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(profile.photoUrl)),
                      )),
                  SizedBox(width: 8),
                  Text(
                    profile.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 50),
        itemCount: recent_posts.length,
        itemBuilder: (BuildContext context, int i) {
          final post = recent_posts[i];
          return ListTile(
              title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ApplyForCompanyScreen(
                          company_uid: recent_posts[i]['uid'],
                          post_uid: recent_posts_uid[i],
                          post_image: recent_posts_photos[i],
                          job_title: recent_posts[i]['job_title'],
                          descreption: recent_posts[i]['descreption'],
                          yearsOfExperience: recent_posts[i]
                              ['experience_years'],
                          location: recent_posts[i]['city'],
                          major: recent_posts[i]['major'],
                          type: recent_posts[i]['type'],
                          timestamp: recent_posts[i]['timestamp'],
                        )),
              ).then((value) {
                print('object');
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                // width: 240,
                // height: 100,
                decoration: BoxDecoration(
                    color: canvasColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            recent_posts_photos.isNotEmpty &&
                                    i < recent_posts_photos.length
                                ? recent_posts_photos[i]
                                : 'https://firebasestorage.googleapis.com/v0/b/careergy-3e171.appspot.com/o/photos%2FCareergy.png?alt=media&token=d5d0a2b7-e143-4644-970d-c63fc573a5ba',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recent_posts[i]['job_title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                recent_posts[i]['descreption'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${recent_posts[i]['experience_years']} years of experience',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(fontSize: 10, color: white),
                              ),
                              Text(
                                'Lcation: ${recent_posts[i]['city']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: white),
                              ),
                              Text(
                                recent_posts[i]['major'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
        });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    EasyLoading.show(status: 'Loading...');
    await _fetchCompanies();
    await _fetchPosts();
    await getRecentPosts();
    EasyLoading.dismiss();
    print(recent_posts.length);
  }

  String recent_posts_note = '';

  List recent_posts = [];
  List recent_posts_photos = [];
  List recent_posts_uid = [];

  bool finish = false;

  Future getRecentPosts() async {
    // Get docs from collection reference
    Query<Map<String, dynamic>> posts_ref = await FirebaseFirestore.instance
        .collection("posts")
        .where('active', isEqualTo: true)
        .orderBy("timestamp", descending: true);
    QuerySnapshot querySnapshot = await posts_ref.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataUid =
        querySnapshot.docs.map((doc) => doc.reference.id).toList();
    setState(() {
      recent_posts = allData;
      recent_posts_uid = allDataUid;
    });
    if (recent_posts.isEmpty) {
      recent_posts_note = 'No recent posts found';
    }
    CollectionReference companies =
        FirebaseFirestore.instance.collection('companies');
    for (var i = 0; i < recent_posts_uid.length; i++) {
      await companies
          .doc(recent_posts[i]['uid'])
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          setState(() {
            recent_posts_photos.add(ds.data().toString().contains('photoUrl')
                ? ds.get('photoUrl')
                : '');
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }

  Future _fetchCompanies() async {
    final companiesSnapshot =
        await FirebaseFirestore.instance.collection('companies').get();

    final List<Company> companies = companiesSnapshot.docs
        .map((doc) => Company.fromJson(doc.data()))
        .toList();

    final allCompaniesUid =
        companiesSnapshot.docs.map((doc) => doc.reference.id).toList();

    setState(() {
      _companies = companies;
      _companiesUid = allCompaniesUid;
    });
  }

  Future _fetchPosts() async {
    final postsSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    final List<Post> posts =
        postsSnapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();

    final allpostsUid =
        postsSnapshot.docs.map((doc) => doc.reference.id).toList();

    setState(() {
      _posts = posts;
      _postsIDs = allpostsUid;
    });
  }

  void _search() {
    setState(() {
      _searchText = _searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: 'Search'),
      backgroundColor: accentCanvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: accentPrimaryColor),
                  ),
                ),
                cursorColor: primaryColor,
                style: TextStyle(color: white),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: _search,
                child: const Text('Search'),
              ),
              const SizedBox(height: 16),
              DefaultTabController(
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      labelColor: primaryColor,
                      unselectedLabelColor: white,
                      tabs: [
                        Tab(text: 'Profiles'),
                        Tab(text: 'Posts'),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        children: [
                          _buildProfileList(),
                          _buildPostList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
