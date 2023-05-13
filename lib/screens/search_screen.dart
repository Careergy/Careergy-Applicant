import 'package:careergy_mobile/screens/company_profile.dart';
import 'package:careergy_mobile/screens/contact_company.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Row(
                children: [
                  SizedBox(
                      width: 64,
                      height: 64,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.network(profile.photoUrl),
                      )),
                  SizedBox(width: 8),
                  Text(profile.name),
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
      itemCount: _posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = _posts[index];
        return ListTile(
          title: InkWell(
            onTap: () {},
            child: Card(
              elevation: 4,
              child: Row(
                children: [
                  SizedBox(
                      width: 64,
                      height: 64,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('f'),
                      )),
                  SizedBox(width: 8),
                  Text('fr'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _fetchCompanies();
    await _fetchPosts();
    print(_posts.isEmpty ? 'loool' : 'nopee');
  }

  Future _fetchCompanies() async {
    final companiesSnapshot =
        await FirebaseFirestore.instance.collection('companies').get();

    final List<Company> companies = companiesSnapshot.docs
        .map((doc) => Company.fromJson(doc.data()))
        .toList();

    setState(() {
      _companies = companies;
    });
  }

  Future _fetchPosts() async {
    final postsSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    final List<Post> posts =
        postsSnapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();

    final allDataUid =
        postsSnapshot.docs.map((doc) => doc.reference.id).toList();

    setState(() {
      _posts = posts;
      _postsIDs = allDataUid;
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
