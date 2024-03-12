import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String?> get localPath async {
  final directory = await getExternalStorageDirectory();

  final checkPathExistence = await Directory(directory?.path ?? '').exists();

  if (checkPathExistence) {
    return directory?.path;
  }

  return null;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/license_epay');
}

writeFile(String bytes) async {
  final file = await localFile;

  print('Path: ${file.path}');

  // Write the file
  file.writeAsString(bytes);
}

Future<String> readFile() async {
  try {
    final file = await localFile;

    // Read the file
    final data = await file.readAsString();

    return data;
  } catch (e) {
    // If encountering an error, return 0
    rethrow;
  }
}
