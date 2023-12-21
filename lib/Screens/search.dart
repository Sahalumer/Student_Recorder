// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myproject/model/user.dart';
import 'package:myproject/servises/userservice.dart';
import 'edituser.dart';
import 'viewuser.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<dynamic> _userList = [];
  late List<dynamic> _filteredUserList = [];
  final _userService = Userservice();
  TextEditingController searchController = TextEditingController();

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
      _filteredUserList = _userList;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  void _filterUserList(String enteredKeyword) {
    List<dynamic> filteredList = _userList.where((user) {
      return user.name!.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();

    setState(() {
      _filteredUserList = filteredList;
    });
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel'),
                ),
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
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('SEARCH PAGE'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: _filterUserList,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'What are you looking for?',
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: _filteredUserList.isEmpty
                    ? const Center(
                        child: Text('Not Found'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _filteredUserList.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Viewuser(
                                  user: _filteredUserList[index],
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: _filteredUserList[index]
                                              .selectedImage !=
                                          null &&
                                      File(_filteredUserList[index]
                                              .selectedImage!)
                                          .existsSync()
                                  ? FileImage(File(_filteredUserList[index]
                                          .selectedImage!))
                                      as ImageProvider<Object>?
                                  : const AssetImage(
                                      'assets/images/userProfile.png'),
                            ),
                            title: Text(
                                _filteredUserList[index].name ?? 'No Name'),
                            subtitle: Text(
                                _filteredUserList[index].study ?? 'No Study'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Edituser(
                                          user: _filteredUserList[index],
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
                                    deleteFormDialog(
                                        context, _filteredUserList[index].id);
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
            ),
          ],
        ),
      ),
    );
  }
}
