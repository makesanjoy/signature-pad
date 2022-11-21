import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<SfSignaturePadState> _signaturePadStateKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Container(
          height: double.infinity,
          child: Column(
            children: [
              SfSignaturePad(
                key: _signaturePadStateKey,
                backgroundColor: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () async {
                        _signaturePadStateKey.currentState!.clear();
                      },
                      child: Text("Clear")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text("Save"),
                      onPressed: () async {
                        final ui.Image image =
                            await _signaturePadStateKey.currentState!.toImage();

                        final ByteData? data = await image.toByteData(
                            format: ui.ImageByteFormat.png);
                        final Uint8List imageBytes = data!.buffer.asUint8List();

                        String img = base64.encode(imageBytes);
                        log(img);
                       // print('64 $img');

                        // final data = await image.toByteData(
                        //     format: ui.ImageByteFormat.png);
                        // final Uint8List imageBytes = await data!.buffer
                        //     .asUint8List(
                        //         data.offsetInBytes, data.lengthInBytes);
                        final String path =
                            (await getApplicationDocumentsDirectory()).path;
                        print(path);

                        final String fileName = '/storage/emulated/0/Documents/Output.png';
                        final File file = File(fileName);
                        await file.writeAsBytes(imageBytes, flush: true);
                      
                        //  String img = await base64.encode(imageBytes);
                        // print(await img);
                        // if (data != null) {
                        //   String img =
                        //       await base64.encode(data.buffer.asUint8List());
                        //   log(img);
                        //   print('64 $img');
                        // }
                      }),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
