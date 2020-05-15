import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

var BOTTOKEN = Platform.environment['BOTTOKEN'];

Future<File> downloadCSV(String fileId, String filename) async {


  var client = http.Client();
  var tgfilePath = await getFilePath(fileId);
  var req = await client.get(Uri.parse(
      'https://api.telegram.org/file/bot${BOTTOKEN}/${tgfilePath}'));
  var bytes = req.bodyBytes;
  var filePath = join(dirname(Platform.script.toFilePath()), 'data', filename);
  var file = File(filePath);
  await file.writeAsBytes(bytes);
  return file;
}

Future<String> getFilePath(String fileId) async {
  var client = http.Client();
  var req = await client.get(
      'https://api.telegram.org/bot${BOTTOKEN}/getFile?file_id=$fileId');
  var json = jsonDecode(req.body);
  return json['result']['file_path'];
}
