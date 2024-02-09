//Profile page

//import 'dart:js';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import '../model/user.dart';
import '../shared/myserverconfig.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final User userdata;
  const ProfilePage({super.key, required this.userdata});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _controlleroldPassword = TextEditingController();
  final TextEditingController _controllernewPassword = TextEditingController();
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My Account",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            )),
        body: Center(
          child: Column(children: [
            Container(
              height: screenHeight * 0.25,
              padding: const EdgeInsets.all(4),
              child: Card(
                  child: Row(children: [
                Container(
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.all(8),
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.4,
                  child: Image.asset(
                    "assets/image/profile.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Text(
                          widget.userdata.username.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Divider(
                          color: Colors.blueGrey,
                        )
                      ],
                    ))
              ])),
            ),
            Container(
              height: screenHeight * 0.035,
              alignment: Alignment.center,
              color: Colors.blue,
              width: screenWidth,
              child: const Text("UPDATE ACCOUNT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    shrinkWrap: true,
                    children: [
                  MaterialButton(
                    onPressed: () {},
                    child: const Text("UPDATE NAME"),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  MaterialButton(
                    onPressed: () {_showPasswordChangeDialog(context);},
                    child: const Text("UPDATE PASSWORD"),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: const Text("UPDATE PHONE NUMBER"),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: const Text("UPDATE ADDRESS"),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const Divider(
                    height: 2,
                  ),
                ])),
          ]),
        ));
  }
  
  Future<void> _showPasswordChangeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _controlleroldPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Old Password',
                  ),
                ),
                TextFormField(
                  controller: _controllernewPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _changePassword(context);
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }
  
  void _changePassword(BuildContext context) {
        String oldPassword = _controlleroldPassword.text;
        String newPassword = _controllernewPassword.text;
    http.post(
        Uri.parse("${MyServerConfig.server}/bookbyte_buyer/php/update_password.php"),
        body: {"userid": widget.userdata.userid, "old_password": oldPassword, "new_password": newPassword}).then((response) {
        print(widget.userdata.userid);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}