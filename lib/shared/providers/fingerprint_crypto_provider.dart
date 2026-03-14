import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/app_exports.dart';

final fingerprintCryptoProvider = FutureProvider<String>((ref) async {
  final saved = await secureStorage.read(key: 'fingerprint');
  if (saved != null) return saved;

  String? uuid = await secureStorage.read(key: 'uuid');
  if (uuid == null) {
    uuid = const Uuid().v4();
    await secureStorage.write(key: 'uuid', value: uuid);
  }

  final deviceInfo = DeviceInfoPlugin();
  String rawData = '';

  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    rawData = [
      uuid,
      info.brand,
      info.model,
      info.device,
      info.hardware,
      info.version.release,
      info.fingerprint,
    ].join('|');
  } else if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    rawData = [
      uuid,
      info.model,
      info.systemVersion,
      info.identifierForVendor ?? uuid,
      info.utsname.machine,
    ].join('|');
  }

  final hash = sha256.convert(utf8.encode(rawData)).toString();

  await secureStorage.write(key: 'fingerprint', value: hash);

  return hash;
});
