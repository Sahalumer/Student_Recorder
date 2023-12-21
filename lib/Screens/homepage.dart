// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myproject/Screens/details.dart';
import 'package:myproject/Screens/search.dart';
import 'package:myproject/model/user.dart';
import 'package:myproject/servises/userservice.dart';
import 'edituser.dart';
import 'gridview.dart';
import 'viewuser.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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

  showSuccesSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              content: const Text('Are you sure you want to delete this?'),
              actions: [
                TextButton(
                    onPressed: () async {
                      var result = await _userService.deleteUser(userId);
                      if (result != null) {
                        Navigator.pop(context);
                        getAllUserDetails();
                        showSuccesSnackBar('User Details Deleted succesfully');
                      }
                    },
                    child: const Text(
                      'delete',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel'),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
            padding: const EdgeInsets.only(right: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Gridview()),
              );
            },
            icon: const Icon(Icons.grid_view),
            padding: const EdgeInsets.only(right: 30),
          ),
        ],
        backgroundColor: Colors.lightBlue,
        title: const Text('HOME PAGE'),
      ),
      body: Container(
        child: _userList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(9),
                itemCount: _userList.length,
                itemBuilder: (context, index) => Card(
                  elevation: 4,
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Viewuser(
                          user: _userList[index],
                        ),
                      ),
                    ),
                    leading: CircleAvatar(
                        backgroundImage: _userList[index].selectedImage !=
                                    null &&
                                File(_userList[index].selectedImage!)
                                    .existsSync()
                            ? FileImage(File(_userList[index].selectedImage!))
                                as ImageProvider<Object>?
                            : const AssetImage(
                                'assets/images/userProfile.png')),
                    title: Text(_userList[index].name ?? 'No Name'),
                    subtitle: Text(_userList[index].study ?? 'No Study'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Edituser(
                                  user: _userList[index],
                                ),
                              ),
                            ).then(
                              (data) {
                                if (data != null) {
                                  getAllUserDetails();
                                  showSuccesSnackBar(
                                      'User updated successfully');
                                }
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteFormDialog(context, _userList[index].id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Detailspage()),
          ).then((data) {
            if (data != null) {
              getAllUserDetails();
              showSuccesSnackBar('User added successfully');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
