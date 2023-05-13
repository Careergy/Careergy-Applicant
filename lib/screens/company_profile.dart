import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/company_about_profile.dart';
import 'package:careergy_mobile/screens/company_jobs_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'apply_for_company_Screen.dart';

class CompanyProfile extends StatefulWidget {
  final String companyName;
  final List jobs;
  final String bio;
  final String image;

  const CompanyProfile({
    required this.companyName,
    required this.jobs,
    required this.bio,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Profile'),
        backgroundColor: canvasColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('image'),
                  const SizedBox(width: 16),
                  Text('Name'),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                TabBar(
                  indicatorColor: canvasColor,
                  labelColor: canvasColor,
                  //padding: EdgeInsets.all(8),
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'About'),
                    Tab(text: 'Jobs'),
                    Tab(text: 'Contact us')
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('About content goes here'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Jobs content goes here'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.email_outlined, color: canvasColor),
                                SizedBox(width: 16),
                                Text('exa@email.com'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.phone, color: canvasColor),
                                SizedBox(width: 16),
                                Text('920000111'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
