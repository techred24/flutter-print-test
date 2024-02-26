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
        // device.id.id
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
  //   printer.add(gen.row([
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
  // ]));
    printer.add(gen.feed(1));
    printer.add(gen.text('SERVICIO METROPOLITANO', styles: const PosStyles(bold: true, align: PosAlign.center)));
    printer.add(gen.text('***CIERRE DE JORNADA***', styles: const PosStyles(bold: true, align: PosAlign.center)));
    printer.add(gen.feed(1));
    printer.add(gen.text('Ruta 102', styles: const PosStyles(bold: true, align: PosAlign.center)));
    printer.add(gen.feed(1));
    printer.add(gen.text('UNIDAD: U-1573   VUELTAS: 6'));
    printer.add(gen.text('OPERADOR: PEDRO VLADIMIR LARA RODRIGUEZ'));
    printer.add(gen.feed(1));
    printer.add(gen.text('BOLETAJE'));
    printer.add(gen.text('\$Tarifa = Cantidad'));
    printer.add(gen.text('\$7.00 = 0'));
    printer.add(gen.text('\$9.00 = 164'));
    printer.add(gen.text('\$11.00 = 187'));
    printer.add(gen.text('\$13.00 = 76'));
    printer.add(gen.text('-------------------'));
    printer.add(gen.text('TOTAL DIF. BARRAS: 1'));
    printer.add(gen.text('TOTAL DIF. MINUTOS: 0'));
    printer.add(gen.text('-------------------'));
    printer.add(gen.text('ABONOS: \$100.00'));
    printer.add(gen.text('FIANZAS: \$0.00'));
    printer.add(gen.text('DIFERENCIAS ULT. V.: \$0.00'));
    printer.add(gen.text('EXCED. DIESEL: \$0.00'));
    printer.add(gen.text('-------------------'));
    printer.add(gen.feed(1));
    printer.add(gen.text('DEPOSITO(+):'));
    printer.add(gen.text('\$669.00'));
    printer.add(gen.feed(2));
    printer.add(gen.text('Estoy de acuerdo en que la informacion arriba senalada es producto de la actividad realizada como operador el dia de hoy.'));
    printer.add(gen.feed(4));
    printer.add(gen.text('Nombre y Firma', styles: const PosStyles(align: PosAlign.center)));
    printer.add(gen.feed(1));
    printer.add(gen.text('FECHA HORA:'));
    printer.add(gen.text('08/02/2024 12:40:56 a.m.'));
    printer.add(gen.feed(4));

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