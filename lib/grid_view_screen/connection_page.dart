import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';

BluetoothState bluetoothState = BluetoothState.UNKNOWN;
List<BluetoothDevice> discoveredDevices = [];

class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});
  static String id = 'Bluetooth';


  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
    initConnection();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.bluetooth.status;
    if (!status.isGranted) {
      await [
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan
      ].request();
    }
  }

  Future<void> initConnection() async {
    FlutterBluetoothSerial.instance.state.then((state) async {
      setState(() {
        bluetoothState = state;
      });
      debugPrint('bluetoothState **********  = $bluetoothState');
      if (bluetoothState == BluetoothState.STATE_ON) {
        await discoverDevices();
      }
    });

    FlutterBluetoothSerial.instance.onStateChanged().listen((state) async {
      setState(() {
        bluetoothState = state;
      });
      debugPrint('bluetoothState **********  = $bluetoothState');
      if (bluetoothState == BluetoothState.STATE_ON) {
        await discoverDevices();
      }
    });
  }

  Future<void> discoverDevices() async {
    discoveredDevices.clear();
    if (bluetoothState == BluetoothState.STATE_OFF) {
      debugPrint('Bluetooth is Disabled * Please Check Bluetooth Connection and Try again **********  = $bluetoothState');
      return;
    }

    if (bluetoothState == BluetoothState.STATE_ON) {
      try {
        var result = await FlutterBluetoothSerial.instance.getBondedDevices();
        setState(() {
          discoveredDevices.addAll(result);
        });
        debugPrint('Found ${discoveredDevices.length} bonded devices');
      } on Exception catch (e) {
        debugPrint('Error discovering devices: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text(
          'Glove connection',
          style: GoogleFonts.pacifico(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kPrimaryColor,
              kPrimaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: BluetoothDeviceList(),
      ),
    );
  }
}

class BluetoothDeviceList extends StatefulWidget {
  @override
  _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
}

class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceDetailScreen(device: device, connection: connection),
        ),
      );
    } catch (e) {
      print('Cannot connect, exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: discoveredDevices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(discoveredDevices[index].name ?? "Unknown Device"),
          subtitle: Text(discoveredDevices[index].address),
          onTap: () => connectToDevice(discoveredDevices[index]),
        );
      },
    );
  }
}

class DeviceDetailScreen extends StatefulWidget {
  final BluetoothDevice device;
  final BluetoothConnection connection;

  DeviceDetailScreen({required this.device, required this.connection});

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  String _message = "";
  StreamSubscription<Uint8List>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.connection.input?.listen((Uint8List data) {
      // Decode the received bytes to a string
      String message = utf8.decode(data);
      setState(() {
        _message = message;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    widget.connection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name ?? "Device Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text("Bluetooth Message:",
                style: TextStyle(
                    fontSize: 18
                )
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _message,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Pitch"),
                      Slider(
                        value: 1.0, // default value
                        min: 0.5,
                        max: 2.0,
                        onChanged: (value) {
                          // Handle pitch change
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("Speed"),
                      Slider(
                        value: 1.0, // default value
                        min: 0.5,
                        max: 2.0,
                        onChanged: (value) {
                          // Handle speed change
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  // Handle microphone button press
                },
                child: Icon(Icons.mic),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }

