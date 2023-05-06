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

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

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
                ),
              ),
              ElevatedButton(
                onPressed: _search,
                child: const Text('Search'),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('companies')
                    .where('name', isGreaterThanOrEqualTo: _searchText)
                    .where('name', isLessThan: '${_searchText}z')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // print('has data');
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['name']),
                          subtitle: Text(data['phone']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    // print('has error');
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // print('else');
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
