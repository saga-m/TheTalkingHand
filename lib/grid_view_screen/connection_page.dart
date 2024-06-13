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

// Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(widget.device.name ?? "Device Details"),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Text("Bluetooth Message:", style: TextStyle(fontSize: 18)),
  //           SizedBox(height: 10),
  //           Container(
  //             width: double.infinity,
  //             padding: EdgeInsets.all(16.0),
  //             decoration: BoxDecoration(
  //               border: Border.all(color: Colors.black),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: Text(
  //               _message,
  //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           Spacer(),
  //         ],
  //       ),
  //     ),
  //   );
  // }




// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../constants.dart';
//
// BluetoothState bluetoothState = BluetoothState.UNKNOWN;
// List<BluetoothDevice> discoveredDevices = [];
//
// class Bluetooth extends StatefulWidget {
//   const Bluetooth({super.key});
//   static String id = 'Bluetooth';
//
//   @override
//   _BluetoothState createState() => _BluetoothState();
// }
//
// class _BluetoothState extends State<Bluetooth> {
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//     initConnection();
//   }
//
//   Future<void> requestPermissions() async {
//     var status = await Permission.bluetooth.status;
//     if (!status.isGranted) {
//       await [
//         Permission.bluetooth,
//         Permission.bluetoothAdvertise,
//         Permission.bluetoothConnect,
//         Permission.bluetoothScan
//       ].request();
//     }
//   }
//
//   Future<void> connectToDevice() async {
//     const String macAddress = "00:18:91:D7:94:2B"; // Replace this with your HC-06's MAC address
//
//     try {
//       // Establish a connection to the specified address.
//       BluetoothConnection connection = await BluetoothConnection.toAddress(macAddress);
//
//       connection.input?.listen((Uint8List data) {
//         print('Data incoming: ${ascii.decode(data)}');
//         connection.output.add(data); // Echo the data back to the sender
//
//         if (ascii.decode(data).contains('!')) {
//           connection.finish(); // Closing connection gracefully
//           print('Disconnecting by local host');
//         }
//       }).onDone(() {
//         print('Disconnected by remote request');
//       });
//
//     } catch (e) {
//       print('Cannot connect, exception occurred: $e');
//     }
//   }
//   Future<void> initConnection() async {
//     FlutterBluetoothSerial.instance.state.then((state) async {
//       setState(() {
//         bluetoothState = state;
//       });
//       debugPrint('bluetoothState **********  = $bluetoothState');
//       if (bluetoothState == BluetoothState.STATE_ON) {
//         await discoverDevices();
//       }
//     });
//
//     FlutterBluetoothSerial.instance.onStateChanged().listen((state) async {
//       setState(() {
//         bluetoothState = state;
//       });
//       debugPrint('bluetoothState **********  = $bluetoothState');
//       if (bluetoothState == BluetoothState.STATE_ON) {
//         await discoverDevices();
//       }
//     });
//   }
//
//   Future<void> discoverDevices() async {
//     discoveredDevices.clear();
//     if (bluetoothState == BluetoothState.STATE_OFF) {
//       debugPrint('Bluetooth is Disabled * Please Check Bluetooth Connection and Try again **********  = $bluetoothState');
//       return;
//     }
//
//     if (bluetoothState == BluetoothState.STATE_ON) {
//       try {
//         var result = await FlutterBluetoothSerial.instance.getBondedDevices();
//         setState(() {
//           discoveredDevices.addAll(result);
//         });
//         debugPrint('Found ${discoveredDevices.length} bonded devices');
//       } on Exception catch (e) {
//         debugPrint('Error discovering devices: $e');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Life Track',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               kcrimaryColor,
//               kPrimaryColor,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,
//           ),
//         ),
//         child: BluetoothDeviceList(),
//       ),
//     );
//   }
// }
//
// class BluetoothDeviceList extends StatefulWidget {
//   @override
//   _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
// }
//
// class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: discoveredDevices.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(discoveredDevices[index].name ?? "Unknown Device"),
//           subtitle: Text(discoveredDevices[index].address),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DeviceDetailScreen(device: discoveredDevices[index]),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class DeviceDetailScreen extends StatelessWidget {
//   final BluetoothDevice device;
//
//   DeviceDetailScreen({required this.device});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(device.name ?? "Device Details"
//         ),
//       ),
//       body: Center(
//         child: Text("Details for ${device.name ?? device.address}"
//         ),
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../constants.dart';
//
// BluetoothState bluetoothState = BluetoothState.UNKNOWN;
// List<BluetoothDevice> discoveredDevices = [];
//
// class Bluetooth extends StatefulWidget {
//   const Bluetooth({super.key});
//   static String id = 'Bluetooth';
//
//   @override
//   _BluetoothState createState() => _BluetoothState();
// }
//
// class _BluetoothState extends State<Bluetooth> {
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//     initConnection();
//   }
//
//
//   Future<void> requestPermissions() async {
//     var status = await Permission.bluetooth.status;
//     if (!status.isGranted) {
//       await [
//         Permission.bluetooth,
//         Permission.bluetoothAdvertise,
//         Permission.bluetoothConnect,
//         Permission.bluetoothScan
//       ].request();
//     }
//     PermissionStatus requestResult = await Permission.bluetooth.request();
//     await Permission.bluetoothAdvertise.request();
//     await Permission.bluetoothConnect.request();
//     await Permission.bluetoothScan.request();
//     if (requestResult == PermissionStatus.granted) {
//       await Permission.bluetooth.request();
//       await Permission.bluetoothAdvertise.request();
//       await Permission.bluetoothConnect.request();
//       await Permission.bluetoothScan.request();
//       // return true;
//     }else{
//       await Permission.bluetooth.request();
//       await Permission.bluetoothAdvertise.request();
//       await Permission.bluetoothConnect.request();
//       await Permission.bluetoothScan.request();
//
//     }
//   }
//
//   Future<void> initConnection() async {
//     FlutterBluetoothSerial.instance.state.then((state) async {
//       setState(() {
//         bluetoothState = state;
//       });
//       debugPrint('bluetoothState **********  = $bluetoothState');
//       if (bluetoothState == BluetoothState.STATE_ON) {
//         await discoverDevices();
//       }
//     });
//
//     FlutterBluetoothSerial.instance.onStateChanged().listen((state) async {
//       setState(() {
//         bluetoothState = state;
//       });
//       debugPrint('bluetoothState **********  = $bluetoothState');
//       if (bluetoothState == BluetoothState.STATE_ON) {
//         await discoverDevices();
//       }
//     });
//   }
//   Future<void> connectToDevice() async {
//     const String macAddress = "00:18:91:D7:94:2B"; // Replace this with your HC-06's MAC address
//
//     try {
//       // Establish a connection to the specified address.
//       BluetoothConnection connection = await BluetoothConnection.toAddress(macAddress);
//
//       connection.input?.listen((Uint8List data) {
//         print('Data incoming: ${ascii.decode(data)}');
//         connection.output.add(data); // Echo the data back to the sender
//
//         if (ascii.decode(data).contains('!')) {
//           connection.finish(); // Closing connection gracefully
//           print('Disconnecting by local host');
//         }
//       }).onDone(() {
//         print('Disconnected by remote request');
//       });
//
//     } catch (e) {
//       print('Cannot connect, exception occurred: $e');
//     }
//   }
//   Future<void> discoverDevices() async {
//     discoveredDevices.clear();
//     if (bluetoothState == BluetoothState.STATE_OFF) {
//       debugPrint('Bluetooth is Disabled * Please Check Bluetooth Connection and Try again **********  = $bluetoothState');
//       return;
//     }
//
//     if (bluetoothState == BluetoothState.STATE_ON) {
//       try {
//         var result = await FlutterBluetoothSerial.instance.getBondedDevices();
//         setState(() {
//           discoveredDevices.addAll(result);
//         });
//         debugPrint('Found ${discoveredDevices.length} bonded devices');
//       } on Exception catch (e) {
//         debugPrint('Error discovering devices: $e');
//       }
//     }
//   }
//   StreamSubscription<List<int>>? _onDataReceivedSubscription;
//
//   Future<void> sendData(String data) async {
//     await FlutterBluetoothSerial.instance.write(utf8.encode(data).toString());
//   }
//
//   Future<void> startListening() async {
//     _onDataReceivedSubscription = FlutterBluetoothSerial.instance.onRead()?.listen((data) {
//       print('Received data: ${String.fromCharCodes(data)}');
//     });
//   }
//
//   Future<void> stopListening() async {
//     if (_onDataReceivedSubscription != null) {
//       await _onDataReceivedSubscription?.cancel();
//       _onDataReceivedSubscription = null;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Life Track',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               kPrimaryColor,
//               kPrimaryColor,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,
//           ),
//         ),
//         child: BluetoothDeviceList(),
//       ),
//     );
//   }
// }
//
// class BluetoothDeviceList extends StatefulWidget {
//   @override
//   _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
// }
//
// class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: discoveredDevices.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(
//             discoveredDevices[index].name ?? "Unknown Device",
//             style: TextStyle(color: Colors.white), // Change text color to white
//           ),
//           subtitle: Text(
//             discoveredDevices[index].address,
//             style: TextStyle(color: Colors.white), // Change text color to white
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DeviceDetailScreen(device: discoveredDevices[index]),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class DeviceDetailScreen extends StatefulWidget {
//   final BluetoothDevice device;
//
//   DeviceDetailScreen({required this.device});
//
//   @override
//   _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
// }
//
// class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
//   TextEditingController _controller = TextEditingController();
//   double _pitch = 1.0;
//   double _speed = 1.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(widget.device.name ?? "Device Details",
//           style: TextStyle(
//               color: Colors.black
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: "Bluetooth Message: ",
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Text(
//                   _controller.text,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 Text("Pitch"),
//                 Expanded(
//                   child: Slider(
//                     value: _pitch,
//                     onChanged: (newPitch) {
//                       setState(() {
//                         _pitch = newPitch;
//                       });
//                     },
//                     min: 0.5,
//                     max: 2.0,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Text("Speed"),
//                 Expanded(
//                   child: Slider(
//                     value: _speed,
//                     onChanged: (newSpeed) {
//                       setState(() {
//                         _speed = newSpeed;
//                       });
//                     },
//                     min: 0.5,
//                     max: 2.0,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// //
// // import '../constants.dart';
// //
// // BluetoothState bluetoothState = BluetoothState.UNKNOWN;
// // List<BluetoothDevice> discoveredDevices = [];
// //
// // class Bluetooth extends StatefulWidget {
// //   const Bluetooth({super.key});
// //   static String id = 'Bluetooth';
// //
// //   @override
// //   _BluetoothState createState() => _BluetoothState();
// // }
// //
// // class _BluetoothState extends State<Bluetooth> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     requestPermissions();
// //     initConnection();
// //   }
// //
// //   Future<void> requestPermissions() async {
// //     var status = await Permission.bluetooth.status;
// //     if (!status.isGranted) {
// //       await [
// //         Permission.bluetooth,
// //         Permission.bluetoothAdvertise,
// //         Permission.bluetoothConnect,
// //         Permission.bluetoothScan
// //       ].request();
// //     }
// //   }
// //
// //   Future<void> initConnection() async {
// //     FlutterBluetoothSerial.instance.state.then((state) async {
// //       setState(() {
// //         bluetoothState = state;
// //       });
// //       debugPrint('bluetoothState **********  = $bluetoothState');
// //       if (bluetoothState == BluetoothState.STATE_ON) {
// //         await discoverDevices();
// //       }
// //     });
// //
// //     FlutterBluetoothSerial.instance.onStateChanged().listen((state) async {
// //       setState(() {
// //         bluetoothState = state;
// //       });
// //       debugPrint('bluetoothState **********  = $bluetoothState');
// //       if (bluetoothState == BluetoothState.STATE_ON) {
// //         await discoverDevices();
// //       }
// //     });
// //   }
// //
// //   Future<void> discoverDevices() async {
// //     discoveredDevices.clear();
// //     if (bluetoothState == BluetoothState.STATE_OFF) {
// //       debugPrint('Bluetooth is Disabled * Please Check Bluetooth Connection and Try again **********  = $bluetoothState');
// //       return;
// //     }
// //
// //     if (bluetoothState == BluetoothState.STATE_ON) {
// //       try {
// //         var result = await FlutterBluetoothSerial.instance.getBondedDevices();
// //         setState(() {
// //           discoveredDevices.addAll(result);
// //         });
// //         debugPrint('Found ${discoveredDevices.length} bonded devices');
// //       } on Exception catch (e) {
// //         debugPrint('Error discovering devices: $e');
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         title: const Text(
// //           'Life Track',
// //           style: TextStyle(
// //             color: Colors.black,
// //           ),
// //         ),
// //         centerTitle: true,
// //         leading: IconButton(
// //           icon: const Icon(
// //             Icons.arrow_back,
// //             color: Colors.black,
// //           ),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //       ),
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [
// //               kPrimaryColor,
// //               kPrimaryColor,
// //             ],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             stops: [0.0, 1.0],
// //             tileMode: TileMode.clamp,
// //           ),
// //         ),
// //         child: BluetoothDeviceList(),
// //       ),
// //     );
// //   }
// // }
// //
// // class BluetoothDeviceList extends StatefulWidget {
// //   @override
// //   _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
// // }
// //
// // class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: discoveredDevices.length,
// //       itemBuilder: (context, index) {
// //         return ListTile(
// //           title: Text(
// //             discoveredDevices[index].name ?? "Unknown Device",
// //             style: TextStyle(color: Colors.white), // Change text color to white
// //           ),
// //           subtitle: Text(
// //             discoveredDevices[index].address,
// //             style: TextStyle(color: Colors.white), // Change text color to white
// //           ),
// //           onTap: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => DeviceDetailScreen(device: discoveredDevices[index]),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // class DeviceDetailScreen extends StatefulWidget {
// //   final BluetoothDevice device;
// //
// //   DeviceDetailScreen({required this.device});
// //
// //   @override
// //   _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
// // }
// //
// // class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
// //   String _message = "";
// //   double _pitch = 1.0;
// //   double _speed = 1.0;
// //   FlutterTts flutterTts = FlutterTts();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _connectToDevice();
// //   }
// //
// //   Future<void> _connectToDevice() async {
// //     // Establish connection to the Bluetooth device
// //     try {
// //       BluetoothConnection connection = await BluetoothConnection.toAddress(widget.device.address);
// //       connection.input!.listen((data) {
// //         String message = String.fromCharCodes(data);
// //         setState(() {
// //           _message = message;
// //         });
// //         _speak(message);
// //       }).onDone(() {
// //         debugPrint('Disconnected from the device');
// //       });
// //     } catch (e) {
// //       debugPrint('Error connecting to the device: $e');
// //     }
// //   }
// //
// //   Future<void> _speak(String message) async {
// //     await flutterTts.setPitch(_pitch);
// //     await flutterTts.setSpeechRate(_speed);
// //     await flutterTts.speak(message);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         title: Text(
// //           widget.device.name ?? "Device Details",
// //           style: TextStyle(
// //             color: Colors.black,
// //           ),
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             Row(
// //               children: [
// //                 Text("Bluetooth Message: "),
// //                 Expanded(
// //                   child: Text(
// //                     _message,
// //                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             Expanded(
// //               child: Center(
// //                 child: Text(
// //                   _message,
// //                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ),
// //             Row(
// //               children: [
// //                 Text("Pitch"),
// //                 Expanded(
// //                   child: Slider(
// //                     value: _pitch,
// //                     onChanged: (newPitch) {
// //                       setState(() {
// //                         _pitch = newPitch;
// //                       });
// //                     },
// //                     min: 0.5,
// //                     max: 2.0,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             Row(
// //               children: [
// //                 Text("Speed"),
// //                 Expanded(
// //                   child: Slider(
// //                     value: _speed,
// //                     onChanged: (newSpeed) {
// //                       setState(() {
// //                         _speed = newSpeed;
// //                       });
// //                     },
// //                     min: 0.5,
// //                     max: 2.0,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// // // import 'dart:async';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // //
// // // import '../constants.dart';
// // //
// // // BluetoothState bluetoothState = BluetoothState.UNKNOWN;
// // // List<BluetoothDevice> discoveredDevices = [];
// // //
// // // class Bluetooth extends StatefulWidget {
// // //   const Bluetooth({super.key});
// // //   static String id = 'Bluetooth';
// // //
// // //   @override
// // //   _BluetoothState createState() => _BluetoothState();
// // // }
// // //
// // // class _BluetoothState extends State<Bluetooth> {
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     requestPermissions();
// // //     initConnection();
// // //   }
// // //
// // //   Future<void> requestPermissions() async {
// // //     var status = await Permission.bluetooth.status;
// // //     if (!status.isGranted) {
// // //       await [
// // //         Permission.bluetooth,
// // //         Permission.bluetoothAdvertise,
// // //         Permission.bluetoothConnect,
// // //         Permission.bluetoothScan
// // //       ].request();
// // //     }
// // //   }
// // //
// // //   Future<void> initConnection() async {
// // //     FlutterBluetoothSerial.instance.state.then((state) async {
// // //       setState(() {
// // //         bluetoothState = state;
// // //       });
// // //       debugPrint('bluetoothState **********  = $bluetoothState');
// // //       if (bluetoothState == BluetoothState.STATE_ON) {
// // //         await discoverDevices();
// // //       }
// // //     });
// // //
// // //     FlutterBluetoothSerial.instance.onStateChanged().listen((state) async {
// // //       setState(() {
// // //         bluetoothState = state;
// // //       });
// // //       debugPrint('bluetoothState **********  = $bluetoothState');
// // //       if (bluetoothState == BluetoothState.STATE_ON) {
// // //         await discoverDevices();
// // //       }
// // //     });
// // //   }
// // //
// // //   Future<void> discoverDevices() async {
// // //     discoveredDevices.clear();
// // //     if (bluetoothState == BluetoothState.STATE_OFF) {
// // //       debugPrint('Bluetooth is Disabled * Please Check Bluetooth Connection and Try again **********  = $bluetoothState');
// // //       return;
// // //     }
// // //
// // //     if (bluetoothState == BluetoothState.STATE_ON) {
// // //       try {
// // //         var result = await FlutterBluetoothSerial.instance.getBondedDevices();
// // //         setState(() {
// // //           discoveredDevices.addAll(result);
// // //         });
// // //         debugPrint('Found ${discoveredDevices.length} bonded devices');
// // //       } on Exception catch (e) {
// // //         debugPrint('Error discovering devices: $e');
// // //       }
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         title: const Text(
// // //           'Life Track',
// // //           style: TextStyle(
// // //             color: Colors.black,
// // //           ),
// // //         ),
// // //         centerTitle: true,
// // //         leading: IconButton(
// // //           icon: const Icon(
// // //             Icons.arrow_back,
// // //             color: Colors.black,
// // //           ),
// // //           onPressed: () {
// // //             Navigator.pop(context);
// // //           },
// // //         ),
// // //       ),
// // //       body: Container(
// // //         width: double.infinity,
// // //         height: double.infinity,
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [
// // //               kcrimaryColor,
// // //               kPrimaryColor,
// // //             ],
// // //             begin: Alignment.topCenter,
// // //             end: Alignment.bottomCenter,
// // //             stops: [0.0, 1.0],
// // //             tileMode: TileMode.clamp,
// // //           ),
// // //         ),
// // //         child: BluetoothDeviceList(),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class BluetoothDeviceList extends StatefulWidget {
// // //   @override
// // //   _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
// // // }
// // //
// // // class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return ListView.builder(
// // //       itemCount: discoveredDevices.length,
// // //       itemBuilder: (context, index) {
// // //         return ListTile(
// // //           title: Text(discoveredDevices[index].name ?? "Unknown Device"),
// // //           subtitle: Text(discoveredDevices[index].address),
// // //           onTap: () {
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(
// // //                 builder: (context) => DeviceDetailScreen(device: discoveredDevices[index]),
// // //               ),
// // //             );
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
// // //
// // // class DeviceDetailScreen extends StatelessWidget {
// // //   final BluetoothDevice device;
// // //
// // //   DeviceDetailScreen({required this.device});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         title: Text(device.name ?? "Device Details",
// // //           style: TextStyle(
// // //             color: Colors.black,
// // //           ),
// // //         ),
// // //       ),
// // //       body: Center(
// // //         child: Text("Details for ${device.name ?? device.address}"
// // //       ),
// // //     ),
// // //     );
// // //   }
// // // }
// //
// //
// // // import 'dart:async';
// // // import 'dart:convert';
// // // import 'dart:typed_data';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // //
// // // import '../constants.dart';
// // //
// // // BluetoothState bluetoothState = BluetoothState.UNKNOWN;
// // // List<BluetoothDevice> discoveredDevices = [];
// // //
// // // class Bluetooth extends StatelessWidget {
// // //   const Bluetooth({super.key});
// // //   static String id = 'Bluetooth';
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         title: const Text(
// // //           'Life Track',
// // //           style: TextStyle(
// // //             color: Colors.black,
// // //           ),
// // //         ),
// // //         centerTitle: true,
// // //         leading: IconButton(
// // //           icon: const Icon(
// // //             Icons.arrow_back,
// // //             color: Colors.black,
// // //           ),
// // //           onPressed: () {
// // //             Navigator.pop(context);
// // //           },
// // //         ),
// // //       ),
// // //       body: Container(
// // //         width: double.infinity,
// // //         height: double.infinity,
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [
// // //               kcrimaryColor,
// // //               kPrimaryColor,
// // //             ],
// // //             begin: Alignment.topCenter,
// // //             end: Alignment.bottomCenter,
// // //             stops: [0.0, 1.0],
// // //             tileMode: TileMode.clamp,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // Future<void> requestPermissions() async {
// // //   var status = await Permission.bluetooth.status;
// // //   if (status.isGranted) {
// // //     await Permission.bluetooth.request();
// // //     await Permission.bluetoothAdvertise.request();
// // //     await Permission.bluetoothConnect.request();
// // //     await Permission.bluetoothScan.request();
// // //   }
// // //
// // //   PermissionStatus requestResult = await Permission.bluetooth.request();
// // //   await Permission.bluetoothAdvertise.request();
// // //   await Permission.bluetoothConnect.request();
// // //   await Permission.bluetoothScan.request();
// // //   if (requestResult == PermissionStatus.granted) {
// // //     await Permission.bluetooth.request();
// // //     await Permission.bluetoothAdvertise.request();
// // //     await Permission.bluetoothConnect.request();
// // //     await Permission.bluetoothScan.request();
// // //   } else {
// // //     await Permission.bluetooth.request();
// // //     await Permission.bluetoothAdvertise.request();
// // //     await Permission.bluetoothConnect.request();
// // //     await Permission.bluetoothScan.request();
// // //   }
// // // }
// // //
// // // Future<void> initConnection() async {
// // //   FlutterBluetoothSerial.instance.state.then((state) async {
// // //     bluetoothState = state;
// // //
// // //     debugPrint('bluetoothState **********  = $bluetoothState');
// // //     if (bluetoothState == BluetoothState.STATE_ON) {
// // //       await discoverDevices();
// // //     }
// // //   });
// // //
// // //   FlutterBluetoothSerial.instance.onStateChanged().listen((state) async {
// // //     bluetoothState = state;
// // //     debugPrint('bluetoothState **********  = $bluetoothState');
// // //     if (bluetoothState == BluetoothState.STATE_ON) {
// // //       await discoverDevices();
// // //     }
// // //   });
// // // }
// // //
// // // Future<void> connectToDevice() async {
// // //   const String macAddress = "00:18:91:D7:94:2B"; // Replace this with your HC-06's MAC address
// // //
// // //   try {
// // //     BluetoothConnection connection = await BluetoothConnection.toAddress(macAddress);
// // //
// // //     connection.input?.listen((Uint8List data) {
// // //       print('Data incoming: ${ascii.decode(data)}');
// // //       connection.output.add(data); // Echo the data back to the sender
// // //
// // //       if (ascii.decode(data).contains('!')) {
// // //         connection.finish(); // Closing connection gracefully
// // //         print('Disconnecting by local host');
// // //       }
// // //     }).onDone(() {
// // //       print('Disconnected by remote request');
// // //     });
// // //
// // //   } catch (e) {
// // //     print('Cannot connect, exception occurred: $e');
// // //   }
// // // }
// // //
// // // Future<void> discoverDevices() async {
// // //   discoveredDevices.clear();
// // //   if (bluetoothState == BluetoothState.STATE_OFF) {
// // //     debugPrint('Bluetooth is Disabled * Please Check Bluetooth Connection and Try again **********  = $bluetoothState');
// // //     return;
// // //   }
// // //
// // //   if (bluetoothState == BluetoothState.STATE_ON) {
// // //     try {
// // //       var result = await FlutterBluetoothSerial.instance.getBondedDevices();
// // //       discoveredDevices.addAll(result);
// // //       debugPrint('Found ${discoveredDevices.length} bonded devices');
// // //     } on Exception catch (e) {
// // //       debugPrint('Error discovering devices: $e');
// // //     }
// // //   }
// // // }
// // //
// // // StreamSubscription<List<int>>? _onDataReceivedSubscription;
// // //
// // // Future<void> sendData(String data) async {
// // //   await FlutterBluetoothSerial.instance.write(utf8.encode(data).toString());
// // // }
// // //
// // // Future<void> startListening() async {
// // //   _onDataReceivedSubscription = FlutterBluetoothSerial.instance.onRead()?.listen((data) {
// // //     print('Received data: ${String.fromCharCodes(data)}');
// // //   });
// // // }
// // //
// // // Future<void> stopListening() async {
// // //   if (_onDataReceivedSubscription != null) {
// // //     await _onDataReceivedSubscription?.cancel();
// // //     _onDataReceivedSubscription = null;
// // //   }
// // // }
// // //
// // // class MyHomePage extends StatefulWidget {
// // //   const MyHomePage({super.key, required this.title});
// // //
// // //   final String title;
// // //
// // //   @override
// // //   State<MyHomePage> createState() => _MyHomePageState();
// // // }
// // //
// // // class _MyHomePageState extends State<MyHomePage> {
// // //   int _counter = 0;
// // //
// // //   void _incrementCounter() async {
// // //     setState(() {
// // //       _counter++;
// // //     });
// // //     await discoverDevices();
// // //     if (discoveredDevices.isNotEmpty) {
// // //       debugPrint('*************** Hello The Result ${discoveredDevices[0].name} *  *** * * ** * *0');
// // //       await connectToDevice();
// // //       await sendData('1');
// // //       await startListening();
// // //     } else {
// // //       debugPrint('No devices found');
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// // //         title: Text(widget.title),
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: <Widget>[
// // //             const Text('You have pushed the button this many times:'),
// // //             Text(
// // //               '$_counter',
// // //               style: Theme.of(context).textTheme.headlineMedium,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         onPressed: _incrementCounter,
// // //         tooltip: 'Increment',
// // //         child: const Icon(Icons.add),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // //
// // // import '../constants.dart';
// // // class Bluetooth extends StatelessWidget {
// // //   const Bluetooth({super.key});
// // //
// // //   static String id = 'Bluetooth';
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         title: const Text(
// // //           'Connection',
// // //           style: TextStyle(
// // //             color: Colors.black,
// // //           ),
// // //         ),
// // //         centerTitle: true,
// // //         leading: IconButton(
// // //           icon: const Icon(
// // //             Icons.arrow_back,
// // //             color: Colors.black,
// // //           ),
// // //           onPressed: () {
// // //             Navigator.pop(context);
// // //           },
// // //         ),
// // //       ),
// // //       body: Container(
// // //         width: double.infinity,
// // //         height: double.infinity,
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [
// // //               kcrimaryColor,
// // //               kPrimaryColor,
// // //             ],
// // //             begin: Alignment.topCenter,
// // //             end: Alignment.bottomCenter,
// // //             stops: [0.0, 1.0],
// // //             tileMode: TileMode.clamp,
// // //           ),
// // //         ),
// // //         child: Row(
// // //
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // // import 'dart:async';
// // // import 'dart:convert';
// // // import 'dart:typed_data';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // //
// // // import '../constants.dart';
// // // BluetoothState bluetoothState = BluetoothState.UNKNOWN;
// // // List<BluetoothDevice> discoveredDevices = [];
// // //
// // //
// // // void main() async{
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await requestPermissions();
// // //   await initConnection();
// // // }
// // //
// // // class Bluetooth extends StatelessWidget {
// // //   const Bluetooth({super.key});
// // //
// // //   static String id = 'Bluetooth';
// // //
// // //   // This widget is the root of your application.
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return  MaterialApp(
// // //       title: 'Flutter Demo',
// // //       theme: ThemeData(
// // //
// // //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// // //         useMaterial3: true,
// // //       ),
// // //       home: const MyHomePage(title: 'Flutter Demo Home Page'),
// // //     );
// // //   }
// // // }
// // //
// // // Future<void> requestPermissions() async {
// // //   var status = await Permission.bluetooth.status;
// // //   if (status.isGranted) {
// // //     await Permission.bluetooth.request();
// // //     await Permission.bluetoothAdvertise.request();
// // //     await Permission.bluetoothConnect.request();
// // //     await Permission.bluetoothScan.request();
// // //     // return true;
// // //   }
// // //
// // //   PermissionStatus requestResult = await Permission.bluetooth.request();
// // //   await Permission.bluetoothAdvertise.request();
// // //   await Permission.bluetoothConnect.request();
// // //   await Permission.bluetoothScan.request();
// // //   if (requestResult == PermissionStatus.granted) {
// // //     await Permission.bluetooth.request();
// // //     await Permission.bluetoothAdvertise.request();
// // //     await Permission.bluetoothConnect.request();
// // //     await Permission.bluetoothScan.request();
// // //     // return true;
// // //   }else{
// // //     await Permission.bluetooth.request();
// // //     await Permission.bluetoothAdvertise.request();
// // //     await Permission.bluetoothConnect.request();
// // //     await Permission.bluetoothScan.request();
// // //
// // //   }
// // //   // return false;
// // // }
// // //
// // // Future<void> initConnection()async {
// // //
// // //   FlutterBluetoothSerial.instance.state.then((state)async{
// // //     bluetoothState=state;
// // //
// // //     debugPrint('bluetoothState **********  = $bluetoothState');
// // //     if(bluetoothState==BluetoothState.STATE_ON){
// // //       await discoverDevices();
// // //     }
// // //
// // //
// // //
// // //
// // //   });
// // //   FlutterBluetoothSerial.instance.onStateChanged().listen((state) async{
// // //
// // //     bluetoothState=state;
// // //     debugPrint('bluetoothState **********  = $bluetoothState');
// // //     if(bluetoothState==BluetoothState.STATE_ON){
// // //       await discoverDevices();
// // //     }
// // //
// // //   });
// // // }
// // //
// // // Future<void> connectToDevice(BluetoothDevice device) async {
// // //   BluetoothConnection connection=  await BluetoothConnection.toAddress(device.address);
// // //
// // //   try{
// // //
// // //     connection.input?.listen((Uint8List data) {
// // //       print('Data incoming: ${ascii.decode(data)}');
// // //       connection.output.add(data); // Sending data
// // //
// // //       if (ascii.decode(data).contains('!')) {
// // //         connection.finish(); // Closing connection
// // //         print('Disconnecting by local host');
// // //       }
// // //     }).onDone(() {
// // //       print('Disconnected by remote request');
// // //     });
// // //   }catch(e){
// // //     print('Cannot connect, exception occured');
// // //
// // //   }
// // // }
// // // Future<void> discoverDevices()async{
// // //   discoveredDevices.clear();
// // //   if(bluetoothState==BluetoothState.STATE_OFF){
// // //     debugPrint('Bluetooth is Disabled * Please Check bluetooth Connection and Try again **********  = $bluetoothState');
// // //     return;
// // //
// // //
// // //   }
// // //   if(bluetoothState==BluetoothState.STATE_ON)
// // //   {
// // //     try{
// // //       // await FlutterBluetoothSerial.instance.startDiscovery().listen((event) {
// // //       //   discoveredDevices.add(event.device);
// // //       // });
// // //       var result= await FlutterBluetoothSerial.instance.getBondedDevices();
// // //       discoveredDevices.addAll(result);
// // //       debugPrint('Found ${discoveredDevices.length} bonded devices');
// // //
// // //
// // //     } on Exception catch(e){
// // //       debugPrint('Error discovering devices: $e');
// // //     }
// // //   }
// // //
// // // }
// // // StreamSubscription<List<int>>? _onDataReceivedSubscription;
// // //
// // // Future<void> sendData(String data) async {
// // //   await FlutterBluetoothSerial.instance.write(utf8.encode(data).toString());
// // // }
// // //
// // // Future<void> startListening() async {
// // //   _onDataReceivedSubscription = FlutterBluetoothSerial.instance.onRead()?.listen((data) {
// // //     print('Received data: ${String.fromCharCodes(data)}');
// // //   });
// // // }
// // //
// // // Future<void> stopListening() async {
// // //   if (_onDataReceivedSubscription != null) {
// // //     await _onDataReceivedSubscription?.cancel();
// // //     _onDataReceivedSubscription = null;
// // //   }
// // // }
// // //
// // // class MyHomePage extends StatefulWidget {
// // //   const MyHomePage({super.key, required this.title});
// // //
// // //
// // //
// // //   final String title;
// // //
// // //   @override
// // //   State<MyHomePage> createState() => _MyHomePageState();
// // // }
// // //
// // // class _MyHomePageState extends State<MyHomePage> {
// // //   int _counter = 0;
// // //
// // //   void _incrementCounter()async{
// // //     setState(() {
// // //
// // //       _counter++;
// // //     });
// // //     await discoverDevices();
// // //     debugPrint(' *************** Hello The Result${    discoveredDevices[0].name} *  *** * * ** * *0');
// // //     await connectToDevice(discoveredDevices[0]);
// // //     await sendData('1');
// // //     await startListening();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //
// // //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// // //
// // //         title: Text(widget.title),
// // //       ),
// // //       body: Center(
// // //
// // //         child: Column(
// // //
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: <Widget>[
// // //             const Text(
// // //               'You have pushed the button this many times:',
// // //             ),
// // //             Text(
// // //               '$_counter',
// // //               style: Theme.of(context).textTheme.headlineMedium,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         onPressed: _incrementCounter,
// // //         tooltip: 'Increment',
// // //         child: const Icon(Icons.add),
// // //       ), // This trailing comma makes auto-formatting nicer for build methods.
// // //     );
// // //   }
// // // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // //
// // // import '../constants.dart';
// // // class ChatPage extends StatelessWidget {
// // //   const ChatPage({super.key});
// // //   static String id = 'ChatPage' ;
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         title:
// // //             Text('Chat',
// // //             style: TextStyle(
// // //               color: Colors.black,
// // //             ),
// // //             ),
// // //         centerTitle: true,
// // //         leading: IconButton(
// // //           icon: Icon(
// // //             Icons.arrow_back,
// // //             color: Colors.black,
// // //           ),
// // //           onPressed: () {
// // //             Navigator.pop(context);
// // //           },
// // //         ),
// // //       ),
// // //     body:Container(
// // //     width: double.infinity,
// // //     height: double.infinity,
// // //     decoration: BoxDecoration(
// // //     gradient: LinearGradient(
// // //     colors: [
// // //     kPrimaryColor,
// // //     kPrimaryColor,
// // //     ],
// // //     begin: Alignment.topCenter,
// // //     end: Alignment.bottomCenter,
// // //     stops: [0.0, 1.0],
// // //     tileMode: TileMode.clamp,
// // //     ),
// // //     ),
// // //       child: Text('hi'),
// // //     )
// // //     );
// // //   }
// // // }
