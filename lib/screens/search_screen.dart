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
        stream: Firestore.instance.collection('tushar').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(
                      '${document['platform']} '
                      '${document['contest']} '
                      '${document['problem']}',
                    ),
                    subtitle: Text(document['notes'] ?? 'No notes'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProblemScreen(document.documentID),
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
