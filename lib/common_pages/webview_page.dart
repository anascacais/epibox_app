import 'package:flutter/material.dart';
import 'package:rPiInterface/utils/mqtt_wrapper.dart';
import 'package:rPiInterface/utils/authentication.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  MQTTClientWrapper mqttClientWrapper;
  ValueNotifier<String> acquisitionNotifier;

  WebviewPage({this.mqttClientWrapper, this.acquisitionNotifier});

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {

  final Auth _auth = Auth();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _stopAcquisition() {
    widget.mqttClientWrapper.publishMessage("['INTERRUPT']");
    _showSnackBar('Aquisição terminada e dados gravados');
  }

  @override
  void initState() {
    super.initState();
    widget.acquisitionNotifier.addListener(() {
      print('IM HERE');
      _showSnackBar(
        widget.acquisitionNotifier.value == 'acquiring'
            ? 'A adquirir dados'
            : widget.acquisitionNotifier.value == 'reconnecting'
                ? 'A retomar aquisição ...'
                : widget.acquisitionNotifier.value == 'stopped'
                    ? 'Aquisição terminada e dados gravados'
                    : 'Aquisição desligada',
      );
    });
  }

  void _showSnackBar(String _message) {
    try {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(
            content: new Text(_message),
            backgroundColor: Colors.blue,));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Visualização'), ),
      key: _scaffoldKey,
      body: WebView(
        initialUrl: 'https://192.168.2.112:8080/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _stopAcquisition(),
        label: Text('Stop'),
        icon: Icon(Icons.stop),
      ),
    );
  }
}
