import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_todo/shared/cubits/task_cubit/task/taskCubit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../models/task.dart';

class QRScannerHome extends StatefulWidget {
  const QRScannerHome({super.key});

  @override
  State<QRScannerHome> createState() => _QRScannerHomeState();
}

class _QRScannerHomeState extends State<QRScannerHome> {
  QRViewController? controller;
  Barcode? result;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
    super.reassemble();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/images/Arrow-Left.svg',
            width: 24,
          ),
        ),
        title: const Text(
          "QR Scanning",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: ConditionalBuilder(
        condition: !Platform.isWindows && !Platform.isLinux&& !Platform.isMacOS&& !Platform.isFuchsia,
        builder: (context) =>  SizedBox(
          height: MediaQuery.of(context).size.height,
          // decoration: const BoxDecoration(gradient: Colors.black12),
          child: Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.blue,
                    borderRadius: 5,
                    borderLength: 20,
                    borderWidth: 5,
                    cutOutSize: 250),
                onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
              ),
            ],
          ),
        ),
        fallback: (context) => const Center(child: Text('X X Not supported for this system X X'),),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.format == BarcodeFormat.qrcode &&
          scanData.code!.isNotEmpty) {
        controller.pauseCamera();
        // go to the task
        navigateToNextScreen(scanData.code.toString());

      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void navigateToNextScreen(String qrData) {
    TaskCubit.get(context).loadSingleTask(qrData).then((value) {
        if(value){
          Navigator.pushNamed(
            context,
            '/task-detail',
            arguments: TaskCubit.taskRepository.singleTask,
          );
          controller?.resumeCamera();
        }else{
          const SnackBar(
              content: Text('Error Opening the Task, Pleas check the QR Code'),
          );
        }
      },
    );

  }
}