import 'dart:io';

import 'package:demo/network/api_client/rest_client.dart';
import 'package:demo/screens/policy/policy.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  final AuthRestClient _apiClient = AuthRestClient.getDefaultInstance();

  File? _file;

  void _uploadPhoto(File file) async {
    var result = await _apiClient.sendPhoto(file);
    if (result.response.statusCode == 200) {
    } else {}
  }

  void _getPhoto() async {
    var result = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        _file = File(result.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_file != null)
              Image.file(
                _file!,
                width: 200,
                height: 200,
              ),
            const SizedBox(
              height: 40,
            ),
            if(_file == null) TextButton(
                onPressed: () {
                  // _getPhoto();
                  showModalBottomSheet(context: context, builder: (context) {
                    return const PolicyDialog();
                  });
                },
                child: const Text("Capture")),
            const SizedBox(
              height: 40,
            ),
            if(_file != null) TextButton(
                onPressed: () {
                  if(_file!= null) {
                    _uploadPhoto(_file!);
                  }
                },
                child: const Text("Send")),
          ],
        ),
      ),
    );
  }
}
