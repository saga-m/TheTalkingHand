// import 'package:flutter/material.dart';
// import '../grid_view_screen/connection_page.dart';
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

// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:get/get.dart';
//
// class BluetoothConnection extends GetxController {
//   FlutterBlue ble =FlutterBlue.instance;
//   Future scanDevices() async{
//     if(await Permission.bluetoothScan.request().isGranted){
//       if(await Permission.bluetoothConnect.request().isGranted){
//         ble.startScan(timeout: Duration(seconds: 20));
//
//         ble.stopScan();
//       }
//     }
//   }
//
//   Future<void> connectToDevice(BluetoothDevice device)async {
//
//     print(device);
//   }
//
//
//
//
//
//   Stream<List<ScanResult>> get scanResults => ble.scanResults;
//
// }
//
//
// // import 'package:flutter_blue/flutter_blue.dart';
// // import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// // import 'package:get/get.dart';
// //
// // class BluetoothConnection extends GetxController{
// //   bool flutterBluePlus = FlutterBluePlus.isScanningNow;
// //   Future scanDevices ()async{
// //     flutterBlue.startScan(timeout: const Duration(seconds: 5));
// //
// //     flutterBlue.stopScan();
// //   }
// //   Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
// // }