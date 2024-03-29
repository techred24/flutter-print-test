import 'dart:math';

import 'package:flutter_blue/flutter_blue.dart';

class BluePrint {
  BluePrint({this.chunkLen = 20});

  final int chunkLen;
  final _data = List<int>.empty(growable: true);

  void add(List<int> data) {
    print(data);
    _data.addAll(data);
  }

  List<List<int>> getChunks() {
    // print('LA LONGITUD DE LOS DATOS AGREGADOS. ${_data.length}');
    final chunks = List<List<int>>.empty(growable: true);
    for (var i = 0; i < _data.length; i += chunkLen) {
      // print(i);
      // print('LA VARIABLE I EN CADA ITERACION');
      chunks.add(_data.sublist(i, min(i + chunkLen, _data.length)));
    }
    // chunks.add(_data);
    return chunks;
  }

  Future<void> printData(BluetoothDevice device) async {
    final List<List<int>> data = getChunks();
    final characs = await _getCharacteristics(device);
    // print(data);
    // print('LOS DATOS PA MANDAR CUANDO SE OBTIENEN LOS CHUNKS CON getChunks');
    // list.firstWhere((book) => book.id == id)
    BluetoothCharacteristic characteristic =  characs.firstWhere((charac) => charac.uuid.toString() == '49535343-8841-43f4-a8d4-ecbe34729bb3' && charac.properties.write);
    for (List<int> chunkToPrint in data) {
      await _tryPrint(characteristic, chunkToPrint);
    }
    // for (BluetoothCharacteristic charac in characs) {
    //   if (charac.uuid.toString() == '49535343-8841-43f4-a8d4-ecbe34729bb3' && charac.properties.write) {

    //     await _tryPrint(charac, data);
    //   }
    // }
  }

  Future<void> _tryPrint(
    BluetoothCharacteristic charac,
    List<int> data,
  ) async {
    // [onCharacteristicWrite] uuid: 49535343-8841-43f4-a8d4-ecbe34729bb3 status: 0
    // List<int> dataList = data;
    print('LA LONGITUD DEL NUEVO ARRAY DE DATOS QUE SE VAN A IMPRIMIR: ${data.length}');
    // var len = dataList.length;
    // var size = 20;
    // List<List<int>> newList = [];
    // for(var i = 0; i< len; i+= size) {
    //     var end = (i+size<len)?i+size:len;
    //     newList.add(dataList.sublist(i,end));
    // }
    // for (List<int> list in newList) {
      try {
        await charac.write(data);
        // print('IMPRIMIO UNA LISTA');
        // print(list);
        // print('LISTA');
        // print('LONGITUD DE LA LISTA: ${list.length}');
      } catch (e) {
        print('ALGO FALLO AL INTETAR ESCRIBIR UNA LISTA PARTIDA');
      }
    // }
  }

  Future<List<BluetoothCharacteristic>> _getCharacteristics(
    BluetoothDevice device,
  ) async {
    final services = await device.discoverServices();
    // print('LA LONGITUD DEL ARREGLO DE SERVICIOS SERVICIOS ${services.length}');
    final res = List<BluetoothCharacteristic>.empty(growable: true);
    for (var i = 0; i < services.length; i++) {
      // print(services[i].characteristics);
      // print('CARACTERISTICAS');
      res.addAll(services[i].characteristics);
    }
    // print('LA LONGITUD DEL ARREGLO DE CARACTERISTICAS: ${res.length}');
    return res;
  }
}