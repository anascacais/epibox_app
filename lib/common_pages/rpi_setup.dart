import 'package:flutter/material.dart';
import 'package:rPiInterface/utils/authentication.dart';
import 'package:rPiInterface/utils/models.dart';
import 'package:rPiInterface/utils/mqtt_wrapper.dart';


// programar button "Usar default" e "Usar novo" para enviar MACAddress para RPi e voltar à HomePage
// programar button "Definir novo default" para enviar MACAddress para RPi e mudar "defaultBIT"

class RPiPage extends StatefulWidget {
  ValueNotifier<MqttCurrentConnectionState> connectionNotifier;
  MQTTClientWrapper mqttClientWrapper;
  MqttCurrentConnectionState connectionState;
  ValueNotifier<bool> receivedMACNotifier;
  ValueNotifier<String> acquisitionNotifier;

  RPiPage(
      {this.mqttClientWrapper,
      this.connectionState,
      this.connectionNotifier,
      this.receivedMACNotifier,
      this.acquisitionNotifier});

  @override
  _RPiPageState createState() => _RPiPageState();
}

class _RPiPageState extends State<RPiPage> {

  String message;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerPEN = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    _controllerPEN.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = '192.168.2.112';
    _controllerPEN.text = 'PEN_MARIANA/Asus_Ana/acquisitions';
  }

  Future<void> _restart() async {
    widget.mqttClientWrapper.publishMessage("['RESTART']");
    setState(() {
      widget.connectionNotifier.value = MqttCurrentConnectionState.DISCONNECTED;
      widget.receivedMACNotifier.value = false;
      widget.acquisitionNotifier.value = 'off';
    });
  }

  Future<void> _setup() async {
    await widget.mqttClientWrapper.prepareMqttClient(_controller.text);
    widget.mqttClientWrapper.publishMessage("['FOLDER', '${_controllerPEN.text}']");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text('Conectividade'), ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ValueListenableBuilder(
                valueListenable: widget.connectionNotifier,
                builder: (BuildContext context,
                    MqttCurrentConnectionState state, Widget child) {
                  return Container(
                    height: 20,
                    color: state == MqttCurrentConnectionState.CONNECTED
                        ? Colors.green[50]
                        : state == MqttCurrentConnectionState.CONNECTING
                            ? Colors.yellow[50]
                            : Colors.red[50],
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          state == MqttCurrentConnectionState.CONNECTED
                              ? 'Conectado ao servidor'
                              : state == MqttCurrentConnectionState.CONNECTING
                                  ? 'A conectar...'
                                  : 'Disconectado do servidor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: widget.receivedMACNotifier,
                builder: (BuildContext context, bool state, Widget child) {
                  return Container(
                    height: 20,
                    color: state ? Colors.green[50] : Colors.red[50],
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          state
                              // && _conn == MqttCurrentConnectionState.CONNECTED)
                              ? 'Conectado ao RPi'
                              : 'Disconectado do RPi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        'Endereço Servidor',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            offset: new Offset(5.0, 5.0))
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          child: TextField(
                              style: TextStyle(color: Colors.grey[600]),
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Endereço',
                              ),
                              onChanged: null),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        'Pasta para armazenamento',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            offset: new Offset(5.0, 5.0))
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          child: TextField(
                              style: TextStyle(color: Colors.grey[600]),
                              controller: _controllerPEN,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Armazenamento',
                              ),
                              onChanged: null),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          _setup();
                        },
                        child: new Text("Conectar"),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _restart();
                        },
                        child: new Text("Reininciar"),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}