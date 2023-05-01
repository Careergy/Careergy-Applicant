import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Keywords {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<String>> getKeywords(String type) async {
    if (type == '') {
      return [];
    }
    List<String> list = [];
    final ref = db.collection('keywords');
    await ref.doc(type).get().then((value){
      List tmp = value.data()!['keys'];
      for (var i = 0; i <  tmp.length; i++) {
        list.add(tmp[i]);
      }
      // list.add(value.data()!['keys'][0]);
      // value.data()?.forEach((key, value) {
      //   list.add(value.toString());
      // });
    });

    return list;
  }
}