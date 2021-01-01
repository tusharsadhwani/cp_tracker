import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProblemScreen extends StatefulWidget {
  final problemId;

  ProblemScreen(this.problemId);

  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  var _disableButton = false;

  void confirmDelete(BuildContext ctx) async {
    bool result = await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Delete Problem?'),
        content: Text("Are you sure you want to delete this problem?"),
        actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );

    if (result) {
      deleteProblem(ctx);
    }
  }

  void deleteProblem(BuildContext ctx) async {
    setState(() {
      _disableButton = true;
    });

    await FirebaseFirestore.instance
        .collection('tushar')
        .doc(widget.problemId)
        .delete();

    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Problem'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('tushar')
              .doc(widget.problemId)
              .get(),
          builder: (ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var problem = (snapshot.data as DocumentSnapshot).data();
              if (problem == null)
                return Center(
                  child: Text('Deleted Successfully.'),
                );
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${problem['platform']} '
                          '${problem['contest']} '
                          '${problem['problem']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Tags: ${problem['tags']}'),
                        SizedBox(
                          height: 15,
                        ),
                        SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            child: Text('${problem['notes']}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: RawMaterialButton(
                      constraints: BoxConstraints(
                        minHeight: 50,
                        maxHeight: 50,
                      ),
                      elevation: 8.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onPressed:
                          _disableButton ? null : () => confirmDelete(ctx),
                      child: Text(
                        "Delete this Problem",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else
              return Center(
                child: Text('Loading...'),
              );
          },
        ),
      ),
    );
  }
}
