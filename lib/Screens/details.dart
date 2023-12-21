// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/model/user.dart';
import 'package:myproject/servises/userservice.dart';

class Detailspage extends StatefulWidget {
  const Detailspage({super.key});

  @override
  State<Detailspage> createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  final _formkey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final studyController = TextEditingController();
  final ageController = TextEditingController();
  final bloodController = TextEditingController();

  var userService = Userservice();
  File? imagepath;
  String? selectedImage;

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
                'Add new user',
                style: TextStyle(
                  fontSize: 25,
                ),
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
                  if (value == null || value.isEmpty) {
                    return 'Name Is Required';
                  } else {
                    return null;
                  }
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
                  if (value == null || value.isEmpty) {
                    return 'class Is Required';
                  } else {
                    return null;
                  }
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
                  if (value == null || value.isEmpty) {
                    return 'Name Is Required';
                  } else {
                    return null;
                  }
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
                  if (value == null || value.isEmpty) {
                    return 'Blood group Is Required';
                  } else {
                    return null;
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(
                height: 14,
              ),
              TextButton.icon(
                  onPressed: () {
                    pickImageFromGallery();
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('ADD A IMAGE')),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.lightBlue)),
                    onPressed: () async {
                      saveDetails();
                    },
                    child: const Text(
                      'Save Data',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      forclear();
                    },
                    child: const Text(
                      'Clear Data',
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

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      imagepath = File(returnedImage.path);
      selectedImage = returnedImage.path.toString();
    });
  }

  void saveDetails() async {
    if (_formkey.currentState!.validate() && selectedImage != null) {
      var user = User();
      user.name = userNameController.text;
      user.study = studyController.text;
      user.age = ageController.text;
      user.blood = bloodController.text;
      user.selectedImage = selectedImage;
      var result = await userService.saveUser(user);
      Navigator.pop(context, result);
    }
    if (selectedImage == null) {}
  }

  void forclear() {
    userNameController.text = '';
    studyController.text = '';
    ageController.text = '';
    bloodController.text = '';
  }
}
