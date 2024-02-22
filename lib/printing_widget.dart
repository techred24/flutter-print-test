// import 'package:thermal_print/blue_print.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';


class PrintingWidget extends StatefulWidget {
  const PrintingWidget({Key key}) : super(key: key);

  @override
  _PrintingWidgetState createState() => _PrintingWidgetState();
}

class _PrintingWidgetState extends State<PrintingWidget> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _deviceMsg;
  @override
  void initState() {
    super.initState();
    initPrinter();
  }
  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      print(val);
      print('SE ENCONTRARON DISPOSITIVOS');
      if(!mounted) return;
      setState(() => _devices = val);
      print(_devices);
      if(_devices.isEmpty)
      setState(() => _deviceMsg = 'No hay dispositivos');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    // final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    // print(result);
    print('SE TERMINO DE IMPRIMIR');
  }
  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    ticket.text(
      'Nueva Dependencia',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.feed(1);
      ticket.row([
        PosColumn(
          text: '\$5.00 x 5',
          width: 6
        ),
        PosColumn(
          text: '\$24.00 x 10',
          width: 6
        )
      ]);
      ticket.feed(1);
      ticket.row([
        PosColumn(text: 'Total', width: 6, styles: PosStyles(bold: true)),
        PosColumn(text: '\$265.00', width: 6, styles: PosStyles(bold: true))
      ]);
      ticket.feed(2);
      ticket.text('¡Gracias!', styles: PosStyles(bold: true, align: PosAlign.center));
      ticket.feed(3);
    return ticket;
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth devices')),
      body: _devices.isEmpty ? Center(child: Text(_deviceMsg ?? ''),) : 
      ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (c, i) {
        return ListTile(
          leading: Icon(Icons.print),
          title: Text(_devices[i].name),
          subtitle: Text(_devices[i].address),
          onTap: () {
            // print(_devices[i]);
            _startPrint(_devices[i]);
          },
        );
      }),
    );
  }
}