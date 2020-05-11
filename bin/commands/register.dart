import 'dart:convert';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'dart:io' as io;


Future<Message> register(Message message, TeleDart teleDart) async {
  String expr;
  String userName;
  DateTime regTime;
  File jsonFile;

  List<Map<String, dynamic>> users;

  // get expirience from reponse
  RegExp exp = RegExp(r'^\/register (.+)$');
  try {
    expr = exp.firstMatch(message.text).group(1);
  } catch (e) {
    return teleDart.replyMessage(message, 'Please provide Your expirience');
  }

  //Adding user name & time of registration
  userName = message.from.username;
  regTime = DateTime.now();

  Map<String, dynamic> result = {
    'userName' : userName,
    'expirience' : expr,
    'time' : regTime,
  };

  //getting the json path
  final String filePath = join(dirname(io.Platform.script.toFilePath()), 'data', 'registered.json'); 

  //getting the json File
  jsonFile = File(file_path: dirname(io.Platform.script.toFilePath()) +'/data/registered.json');


  try {
    users = jsonDecode(filePath);
    users.add(result);
    await io.File(jsonFile.file_path).writeAsStringSync(jsonEncode(users));
    return teleDart.replyMessage(message, 'User Added');
  } catch (e) {
    return teleDart.replyMessage(message, 'OOPs Something went Wrong!');
  }

  

}
