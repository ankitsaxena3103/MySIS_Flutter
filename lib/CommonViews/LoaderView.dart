

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/NetworkConnectivity.dart';
import 'package:mysis/CommonViews/Utility.dart';


class LoaderView extends StatefulWidget{

  final bool isVisible;
  late final String message;

   LoaderView({super.key, required this.isVisible, required this.message});

  @override
  LoaderViewState createState() => LoaderViewState();
}

class LoaderViewState extends State<LoaderView> {

  Map source = {ConnectivityResult.none: false};
  NetworkConnectivity connection = NetworkConnectivity.instance;
  bool isInternet = true;

  @override
  void initState() {
    super.initState();
    connection.myStream.listen((_source) {
      source = _source;
      onConnectionChange();
    });

  }
  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: widget.isVisible,
      child: Stack(
        children: [
          Container(
            width: logicalWidth,
            height: logicalHeight,
            color: Colors.black.withOpacity(0.3),
          ),
          //add gif  here assets/gifs/dice-roll_red.gif
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return Image.asset(
                      "assets/gifs/loader.gif",
                      width: pathS/2,
                      height: pathS/2,
                      fit: BoxFit.contain,
                    );
                  }
                ),
                SizedBox(height: pathS/15),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: pathS / 4,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Visibility(
                  visible: !isInternet,
                  child: Icon(
                    Icons.wifi_off,
                    size: pathS / 2.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  void onConnectionChange(){

    bool isConnected = true;

    switch (source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        isConnected = true;
        break;
      case ConnectivityResult.wifi:
        isConnected = true;
        break;
      case ConnectivityResult.none:
      default:
        isConnected = false;
    }

    printInDebug('connection status = ${source.keys.toList()[0]}');

    setState(() {
      isInternet = isConnected;
    });

  }

}
