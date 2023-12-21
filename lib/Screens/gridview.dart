import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myproject/model/user.dart';
import 'package:myproject/servises/userservice.dart';
import 'viewuser.dart';

class Gridview extends StatefulWidget {
  const Gridview({Key? key});
  @override
  State<Gridview> createState() => _Gridview();
}

class _Gridview extends State<Gridview> {
  late List<dynamic> _userList = [];
  final _userService = Userservice();

  getAllUserDetails() async {
    var users = await _userService.readAllUsers();
    setState(() {
      _userList = users.map((user) {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.study = user['study'];
        userModel.age = user['age'];
        userModel.blood = user['blood'];
        userModel.selectedImage = user['selectedImage'];
        return userModel;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.list),
            padding: const EdgeInsets.only(right: 30),
          )
        ],
        backgroundColor: Colors.lightBlue,
        title: const Text('GRID VIEW'),
      ),
      body: Container(
        child: _userList.isEmpty
            ? const Center(
                child: Text('No Data'),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 18,
                ),
                itemCount: _userList.length,
                itemBuilder: (context, index) => Card(
                  // elevation: 9,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Viewuser(
                          user: _userList[index],
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _userList[index].selectedImage !=
                                        null &&
                                    File(_userList[index].selectedImage!)
                                        .existsSync()
                                ? FileImage(
                                        File(_userList[index].selectedImage!))
                                    as ImageProvider<Object>?
                                : const AssetImage(
                                    'assets/images/userProfile.png'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _userList[index].name ?? 'No Name',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            _userList[index].study ?? 'No Study',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
