import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'problem_screen.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tushar').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  final note = document['notes'] as String ?? '';
                  final firstLine = note.trim().split('\n')[0];
                  final subtitle = firstLine.length > 50
                      ? _firstFewWords(firstLine) + '...'
                      : firstLine;

                  return ListTile(
                    title: Text(
                      '${document['platform']} '
                      '${document['contest']} '
                      '${document['problem']}',
                    ),
                    subtitle: Text(subtitle),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProblemScreen(document.id),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}

String _firstFewWords(String line) {
  final words = line.split(' ').reversed.toList();
  var ret = words.removeLast();
  while (words.length > 0 && ret.length < 100) {
    var word = words.removeLast();
    ret += ' ' + word;
  }
  return ret;
}
