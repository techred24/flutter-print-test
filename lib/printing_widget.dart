import 'package:thermal_print/blue_print.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class PrintingWidget extends StatefulWidget {
  const PrintingWidget({Key key}) : super(key: key);

  @override
  _PrintingWidgetState createState() => _PrintingWidgetState();
}

class _PrintingWidgetState extends State<PrintingWidget> {
  List<ScanResult> scanResult;

  @override
  void initState() {
    super.initState();
    findDevices();
  }

  void findDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResult = results;
      });
    });
    flutterBlue.stopScan();
  }

  void printWithDevice(BluetoothDevice device) async {
    await device.connect();
    final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
    final printer = BluePrint();
    // printer.add(gen.qrcode('https://altospos.com'));
  //   var fila = gen.row([
  //   PosColumn(
  //     text: 'col3',
  //     width: 3,
  //     styles: PosStyles(align: PosAlign.center, underline: true),
  //   ),
  //   PosColumn(
  //     text: 'col6',
  //     width: 6,
  //     styles: PosStyles(align: PosAlign.center, underline: true),
  //   ),
  //   PosColumn(
  //     text: 'col3',
  //     width: 3,
  //     styles: PosStyles(align: PosAlign.center, underline: true),
  //   ),
  // ]);
  //   printer.add(fila);
  //   print(fila);
  //   print('LO QUE CONTIENE LA FILA');
  //   print(fila.length);
  //   print('LONGITUD DE LA FILA');
    // printer.add(fila);
    printer.add(gen.text('123456789A'));
    // printer.add(gen.text('IMPRIMIENDO'));
    // printer.add(gen.text('VARIAS COSAS A LA VEZ'));
    // printer.add(gen.text('AGAING'));
    // printer.add(gen.text('LINEA APLICANDO ESTILOS', styles: const PosStyles(bold: true)));
    printer.add(gen.feed(1));
    await printer.printData(device);
    device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth devices')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(scanResult[index].device.name),
            subtitle: Text(scanResult[index].device.id.id),
            onTap: () => printWithDevice(scanResult[index].device),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: scanResult?.length ?? 0,
      ),
    );
  }
}