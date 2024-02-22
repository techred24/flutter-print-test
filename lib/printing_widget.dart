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
      'SERVICIO METROPOLITANO',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
    ticket.text(
      '***CIERRE DE JORNADA***',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.feed(1);
      ticket.text(
      'Ruta 102',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.row([
        PosColumn(
          text: 'UNIDAD: U-1573',
          width: 6
        ),
        PosColumn(
          text: 'VUELTAS: 6',
          width: 6
        )
      ]);
      ticket.text(
      'OPERADOR: PEDRO VLADIMIR LARA RODRIGUEZ',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.feed(1);
      ticket.text(
      'OPERADOR: PEDRO VLADIMIR LARA RODRIGUEZ',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      'BOLETAJE:',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      '\$Tarifa = Cantidad',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));

      ticket.text(
      '\$7 = 0',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      '\$9 = 164',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      '\$11 = 187',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      '\$13 = 76',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));

      ticket.text(
      '---------------',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));

      ticket.text(
      'TOTAL DIF. BARRAS: 1',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      'TOTAL DIF. MINUTOS: 0',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      '---------------',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      'ABONOS: \$100.00',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      'FIANZAS: \$0.00',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      'DIFERENCIAS ULT. V.: \$0.00',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      'EXCED. DIESEL: \$0.00',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));

      ticket.text(
      '---------------',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.feed(1);
      ticket.text(
      'DEPOSITO(+):',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.text(
      '\$669.00',
      styles: PosStyles(
        // align: PosAlign.left,
        height: PosTextSize.size8,
        width: PosTextSize.size1,
        bold: true
      ));
      ticket.feed(2);
      ticket.text('Estoy de acuerdo en que la informacion arriba señalada es producto de la actividad realizada como operador el dia de hoy.', styles: PosStyles(bold: true, align: PosAlign.center));
      ticket.feed(3);
      ticket.text('Nombre y Firma', styles: PosStyles(bold: true, height: PosTextSize.size8,
        width: PosTextSize.size1, align: PosAlign.center));
      ticket.feed(1);
      ticket.text('FECHA Y HORA:', styles: PosStyles(bold: true, height: PosTextSize.size8,
      width: PosTextSize.size1));
      ticket.text('08/02/2024 12:40:56 a.m.', styles: PosStyles(bold: true, height: PosTextSize.size8,
      width: PosTextSize.size1));
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