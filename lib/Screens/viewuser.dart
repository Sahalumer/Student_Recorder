import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myproject/model/user.dart';

class Viewuser extends StatelessWidget {
  final User user;

  const Viewuser({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('STUDENT INFO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 90),
              child: Text(
                "STUDENT INFO",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (user.selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.file(
                      File(user.selectedImage!),
                      fit: BoxFit.cover,
                      width: 290,
                      height: 300,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            _buildDetailRow('Name', user.name ?? ''),
            _buildDetailRow('Class', user.study ?? ''),
            _buildDetailRow('Age', user.age ?? ''),
            _buildDetailRow('Blood', user.blood ?? ''),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget to build a row for each detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
