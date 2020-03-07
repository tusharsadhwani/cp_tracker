import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  var _formData = Map<String, String>();
  var _platformFocusNode = FocusNode();
  var _contestFocusNode = FocusNode();
  var _problemFocusNode = FocusNode();
  var _notesFocusNode = FocusNode();
  var _disableButton = false;

  @override
  void dispose() {
    _platformFocusNode.dispose();
    _contestFocusNode.dispose();
    _problemFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  void createRecord(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      print("Invalid form");
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _disableButton = true;
    });

    DocumentReference ref = await databaseReference.collection("tushar").add({
      'platform': _formData['platform'],
      'contest': _formData['contest'],
      'problem': _formData['problem'],
      'notes': _formData['notes'],
    });

    _formKey.currentState.reset();

    setState(() {
      _disableButton = false;
    });

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Created document ${ref.documentID}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(child: null),
            ListTile(
              title: Text('Search'),
              onTap: () => Navigator.of(context).pushNamed('/list'),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          hint: Text(_formData.containsKey('platform')
                              ? _formData['platform']
                              : 'Platform...'),
                          items: [
                            DropdownMenuItem(
                              child: Text('Codeforces'),
                              value: 'Codeforces',
                            ),
                            DropdownMenuItem(
                              child: Text('CodeChef'),
                              value: 'CodeChef',
                            ),
                          ],
                          onChanged: (value) {
                            _formData['platform'] = value;
                            FocusScope.of(context)
                                .requestFocus(_contestFocusNode);
                          },
                          onSaved: (value) => _formData['platform'] = value,
                          validator: (value) {
                            if (value == null) return "Choose Platform";
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Contest',
                          ),
                          focusNode: _contestFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_problemFocusNode),
                          onSaved: (value) {
                            _formData['contest'] = value.trim();
                          },
                          validator: (value) {
                            if (value.trim().length == 0)
                              return "Enter Contest Name";
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Problem',
                          ),
                          focusNode: _problemFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_notesFocusNode),
                          onSaved: (value) {
                            _formData['problem'] = value.trim();
                          },
                          validator: (value) {
                            if (value.trim().length == 0)
                              return "Enter Problem Name";
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Notes',
                    ),
                    focusNode: _notesFocusNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    onSaved: (value) {
                      _formData['notes'] = value.trim();
                    },
                    validator: (value) {
                      if (value.trim().length == 0) return "Enter Notes";
                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: _disableButton ? null : () => createRecord(ctx),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
