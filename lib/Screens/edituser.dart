// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';
import '../servises/userservice.dart';

class Edituser extends StatefulWidget {
  final User user;
  const Edituser({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Edituser> createState() => _EdituserState();
}

class _EdituserState extends State<Edituser> {
  final userNameController = TextEditingController();
  final studyController = TextEditingController();
  final ageController = TextEditingController();
  final bloodController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var userService = Userservice();
  File? imagepath;
  String? selectedImage;
  @override
  void initState() {
    setState(() {
      userNameController.text = widget.user.name ?? '';
      studyController.text = widget.user.study ?? '';
      ageController.text = widget.user.age ?? '';
      bloodController.text = widget.user.blood ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Details page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit user',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: userNameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Name Is Empty'
                      : null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: studyController,
                decoration: const InputDecoration(
                  labelText: 'Class',
                  hintText: 'Enter your class',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Name Is Empty'
                      : null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: ageController,
                // maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Name Is Empty'
                      : null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: bloodController,
                decoration: const InputDecoration(
                  labelText: 'Blood Group',
                  hintText: 'Enter your blood group',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Name Is Empty'
                      : null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(
                height: 15,
              ),

              TextButton.icon(
                  onPressed: () {
                    pickImageFromGallery();
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('UPDATE IMAGE')),
              const SizedBox(
                height: 15,
              ),

              // selectedImage != null ? Image.file(imagepath!) : Text(""),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.lightBlue)),
                    onPressed: () {
                      updateDetails();
                    },
                    child: const Text(
                      'Update data',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.lightBlue)),
                    onPressed: () {
                      forClear();
                    },
                    child: const Text(
                      'Clear data',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void forClear() {
    userNameController.text = '';
    studyController.text = '';
    ageController.text = '';
    bloodController.text = '';
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      imagepath = File(returnedImage.path);
      selectedImage = returnedImage.path.toString();
    });
  }

  updateDetails() async {
    if (_formkey.currentState!.validate()) {
      // print("data can save");
      var user = User();
      user.id = widget.user.id;
      user.name = userNameController.text;
      user.study = studyController.text;
      user.age = ageController.text;
      user.blood = bloodController.text;
      user.selectedImage = selectedImage;
      var result = await userService.updateUser(user);
      Navigator.pop(context, result);
    }
  }
}
