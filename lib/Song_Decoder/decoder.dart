import 'dart:convert';
import 'package:dart_des/dart_des.dart';

// Fix JioSaavn's broken Base64
String normalizeBase64(String input) {
  input = input.replaceAll('-', '+').replaceAll('_', '/');
  while (input.length % 4 != 0) {
    input += '=';
  }
  return input;
}

List<DownloadLink>? createDownloadLinks(String encryptedMediaUrl) {
  if (encryptedMediaUrl.isEmpty) return null;

  const key = '38346591';

  // FIX BASE64
  final encryptedBytes = base64.decode(normalizeBase64(encryptedMediaUrl));

  // DES decrypt
  final des = DES(
    key: key.codeUnits,
    mode: DESMode.ECB,
    paddingType: DESPaddingType.PKCS7,
  );
  
  final decryptedBytes = des.decrypt(encryptedBytes);
  final decryptedUrl = utf8.decode(decryptedBytes);

  // Quality replacements
  const qualities = [
    (id: '_12', bitrate: '12kbps'),
    (id: '_48', bitrate: '48kbps'),
    (id: '_96', bitrate: '96kbps'),
    (id: '_160', bitrate: '160kbps'),
    (id: '_320', bitrate: '320kbps'),
  ];

  return qualities.map((q) {
    return DownloadLink(
      quality: q.bitrate,
      link: decryptedUrl.replaceAll('_96', q.id),
    );
  }).toList();
}

// Simple model
class DownloadLink {
  final String quality;
  final String link;

  DownloadLink({required this.quality, required this.link});
}
List<DownloadLink>? createDownloadLinks320kbps(String encryptedMediaUrl) {
  if (encryptedMediaUrl.isEmpty) return null;

  const key = '38346591';

  // FIX BASE64
  final encryptedBytes = base64.decode(normalizeBase64(encryptedMediaUrl));

  // DES decrypt
  final des = DES(
    key: key.codeUnits,
    mode: DESMode.ECB,
    paddingType: DESPaddingType.PKCS7,
  );
  
  final decryptedBytes = des.decrypt(encryptedBytes);
  final decryptedUrl = utf8.decode(decryptedBytes);

  // Quality replacements
  const qualities = [
    (id: '_12', bitrate: '12kbps'),
    (id: '_48', bitrate: '48kbps'),
    (id: '_96', bitrate: '96kbps'),
    (id: '_160', bitrate: '160kbps'),
    (id: '_320', bitrate: '320kbps'),
  ];

  return qualities.map((q) {
    return DownloadLink(
      quality: q.bitrate,
      link: decryptedUrl.replaceAll('_320', q.id),
    );
  }).toList();
}


List<DownloadLink>? createDownloadLinks320kbps1(String encryptedMediaUrl) {
  if (encryptedMediaUrl.isEmpty) return null;

  const key = '38346591';

  try {
    // FIX BASE64
    final encryptedBytes =
        base64.decode(normalizeBase64(encryptedMediaUrl));

    // DES decrypt
    final des = DES(
      key: key.codeUnits, // 8 bytes
      mode: DESMode.ECB,
      paddingType: DESPaddingType.PKCS7,
    );

    final decryptedBytes = des.decrypt(encryptedBytes);
    final decryptedUrl = utf8.decode(decryptedBytes);

    // Force 320 kbps (replace any quality)
    final url320 = decryptedUrl.replaceAll(
      RegExp(r'_(12|48|96|160|320)'),
      '_320',
    );

    return [
      DownloadLink(
        quality: '320kbps',
        link: url320,
      )
    ];
  } catch (e) {
    return null;
  }
}
List<DownloadLink> createDownloadLinksMaxQuality(String encryptedMediaUrl) {
  const key = '38346591';

  final List<DownloadLink> links = [];

  try {
    final encryptedBytes =
        base64.decode(normalizeBase64(encryptedMediaUrl));

    final des = DES(
      key: key.codeUnits,
      mode: DESMode.ECB,
      paddingType: DESPaddingType.PKCS7,
    );

    final decryptedUrl =
        utf8.decode(des.decrypt(encryptedBytes));

    const qualities = [
      ('_320', '320kbps'),
      ('_160', '160kbps'),
      ('_96', '96kbps'),
      ('_48', '48kbps'),
      ('_12', '12kbps'),
    ];

    for (final q in qualities) {
      final url = decryptedUrl.replaceAll(
        RegExp(r'_(12|48|96|160|320)'),
        q.$1,
      );

      links.add(DownloadLink(
        quality: q.$2,
        link: url,
      ));
    }
  } catch (_) {}

  return links;
}
