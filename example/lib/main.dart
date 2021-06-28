import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_loader/image_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Loader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Image Loader Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String networkImageUrl =
      'https://i.pinimg.com/originals/a4/f8/f9/a4f8f91b31d2c63a015ed34ae8c13bbd.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ImageHelper(
              imageType: ImageType.network,
              imageShape: ImageShape.circle,
              width: MediaQuery.of(context).size.width,
              boxFit: BoxFit.none,
              scale: 4.0,
              // imagePath: 'assets/images/image.png',
              image: networkImageUrl,
              defaultLoaderColor: Colors.red,
              defaultErrorBuilderColor: Colors.blueGrey,
            ),
            flex: 1,
          ),
          Expanded(
            child: ImageHelper(
              imageType: ImageType.network,
              imageShape: ImageShape.oval,
              boxFit: BoxFit.fill,
              // imagePath: 'assets/images/image.png',
              image: networkImageUrl,
              defaultLoaderColor: Colors.red,
              defaultErrorBuilderColor: Colors.blueGrey,
            ),
            flex: 1,
          ),
          Expanded(
            child: ImageHelper(
              imageType: ImageType.network,
              imageShape: ImageShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              boxFit: BoxFit.fill,
              // imagePath: 'assets/images/image.png',
              image: networkImageUrl,
              defaultLoaderColor: Colors.red,
              color: Colors.blue,
              blendMode: BlendMode.hue,
              defaultErrorBuilderColor: Colors.blueGrey,
              loaderBuilder: _loader,
            ),
            flex: 1,
          ),
          Expanded(
            child: ImageHelper(
              image: networkImageUrl,
              // image scale
              scale: 1.0,
              // Quality levels for image sampling in [ImageFilter] and [Shader] objects that sample
              filterQuality: FilterQuality.high,
              // border radius only work with [ImageShape.rounded]
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              // alignment of image
              alignment: Alignment.center,
              // indicates where image will be loaded from, types are [network, asset,file]
              imageType: ImageType.network,
              // indicates what shape you would like to be with image [rectangle, oval,circle or none]
              imageShape: ImageShape.rectangle,
              // image default box fit
              boxFit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // imagePath: 'assets/images/image.png',
              // default loader color, default value is null
              defaultLoaderColor: Colors.red,
              // default error builder color, default value is null
              defaultErrorBuilderColor: Colors.blueGrey,
              // the color you want to change image with
              color: Colors.blue,
              // blend mode with image only
              blendMode: BlendMode.srcIn,
              // error builder widget, default as icon if null
              errorBuilder: _errorBuilderIcon,
              // loader builder widget, default as icon if null
              loaderBuilder: _loader,
            ),
            flex: 1,
          ),
        ],
      ),
    );

  }

  Widget get _loader =>  SpinKitWave(
  color: Colors.redAccent,
  size: 100000,
  type: SpinKitWaveType.start,
  );

  Widget get _errorBuilderIcon=> Icon(Icons.image_not_supported, size: 10000,);
}
