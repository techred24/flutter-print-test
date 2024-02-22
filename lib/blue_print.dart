import 'dart:math';

import 'package:flutter_blue/flutter_blue.dart';

class BluePrint {
  BluePrint({this.chunkLen = 512});

  final int chunkLen;
  final _data = List<int>.empty(growable: true);

  void add(List<int> data) {
    _data.addAll(data);
  }

  List<List<int>> getChunks() {
    final chunks = List<List<int>>.empty(growable: true);
    for (var i = 0; i < _data.length; i += chunkLen) {
      print(chunkLen);
      print('EL chunkLen-----------');
      print(i);
      print('LA VARIABLE I EN CADA ITERACION');
      chunks.add(_data.sublist(i, min(i + chunkLen, _data.length)));
    }
    return chunks;
  }

  Future<void> printData(BluetoothDevice device) async {
    final data = getChunks();
    final characs = await _getCharacteristics(device);
    for (var i = 0; i < characs.length; i++) {
      // print(characs[i]);
      // print('CARACTERISTICA EN EL ARRAY');
      // print(characs[i].properties);
      // print('CARACTERISTICA PROPIEDADES');
      print(data);
      print('LOS DATOS PA MANDAR');
      // print(data[0].length);
      // print('LONGITUD DEL ARRAY DE LOS ELEMENTOS');

      if (await _tryPrint(characs[i], data)) {
        break;
      }
    }
  }

  Future<bool> _tryPrint(
    BluetoothCharacteristic charac,
    List<List<int>> data,
  ) async {
    for (var i = 0; i < data.length; i++) {
      try {
        await charac.write(data[i]);
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  Future<List<BluetoothCharacteristic>> _getCharacteristics(
    BluetoothDevice device,
  ) async {
    final services = await device.discoverServices();
    final res = List<BluetoothCharacteristic>.empty(growable: true);
    for (var i = 0; i < services.length; i++) {
      print(services[i].characteristics);
      print('CARACTERISTICAS');
      res.addAll(services[i].characteristics);
    }
    return res;
  }
}