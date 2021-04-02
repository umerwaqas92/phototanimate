import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:phototanimate/vide_play.dart';
// import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}






class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;



  File _image;
  final picker = ImagePicker();



  // var req = http.MultipartRequest('POST', Uri.parse("https://4b1efaa037e4.ngrok.io"));

  Future<String> uploadImage(filename, url) async {
    print("uplading started");
    print("url "+filename);

    final encoding = Encoding.getByName('utf-8');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));





    request.files.add(await http.MultipartFile.fromPath('file', filename));

    var res = await request.send();

    final resp = await http.Response.fromStream(res);

    print("uplading done");
    print(resp.body);

    final String urlvideoo=url+"/"+resp.body;



    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayVideo(urlvideoo)));
    // dismissProgressDialog();

    // _controller = VideoPlayerController.network(urlvideoo);
    // await _controller.initialize();


    // res.stream.bytesToString().then((value) {
    //   print(value);
    //   // print(request.url);
    //
    // });




    return urlvideoo;
  }


  // VideoPlayerController _controller;





  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );


    setState(() {
      if (pickedFile != null) {
        _image = File(croppedFile.path);

      } else {
        print('No image selected.');
      }
    });
  }



  void _incrementCounter() {
    setState(() {
      getImage();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:Center(
    child: _image == null
    ? Text('No image selected.')
        : InkWell(child: Image.file(_image),onTap: (){


      final String url="https://95a68b7e0a38.ngrok.io";
      // showProgressDialog(context: context);
      uploadImage(_image.absolute.path, url);



      // BetterPlayer.network(url);

    },),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
