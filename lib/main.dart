import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_dart/password_dart.dart';
import 'package:permission_handler/permission_handler.dart';

import 'alert.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Identify License',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

String hashData(String password) {
  const _salt = "CnVgpHFHHDWMSXxb8ZA1wibn0XkI6y5U4eKgh9oDqNQFfg13Fe";
  final inputSalt = hex.encode(utf8.encode(_salt));

  return Password.hash(password, PBKDF2(salt: inputSalt));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isSuccess = false;
  bool _isLoading = false;

  static const _splitContent = '\$pcks\$64,10000,64\$';
  static const _password = "GIMggyZCQpDjHvZzBkpYGOz6lj3kejDiKRtgTbuRSYm1X3maoX";

  genLicense() async {
    setState(() {
      _isSuccess = false;
      _isLoading = true;
    });
    // final licenseHashed = Password.hash(_password, PBKDF2(salt: inputSalt));

    final licenseHashed = await compute(hashData, _password);
    writeLicense(licenseHashed);
  }

  writeLicense(String licenseHashed) async {
    final inputPassword = hex.encode(utf8.encode(_password));

    final licenceSplit =
        licenseHashed.substring(_splitContent.length, licenseHashed.length);

    final content = inputPassword + licenceSplit;
    writeFile(content);
    setState(() {
      _isSuccess = true;
      _isLoading = false;
    });
  }

  requestPermission() async {
    await [Permission.storage].request();
  }

  checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      genLicense();
    } else {
      // ignore: use_build_context_synchronously
      showERbAlertDialog(
        context: context,
        content: (context) => const Text(
            'Bạn cần cấp quyền sử dụng bộ nhớ để ứng dụng hoạt động'),
      );
    }
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'E-Identify License',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: size.width / 4,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : checkPermission,
              child: const Text(
                'Kích hoạt',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            if (_isLoading)
              const Column(
                children: [
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            const SizedBox(height: 20),
            if (_isSuccess)
              const Column(
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kích hoạt thành công',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
