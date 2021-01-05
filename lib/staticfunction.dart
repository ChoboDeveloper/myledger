import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class staticfunction{
  static final NumberFormat currencyformatter = NumberFormat("#,###");
  static DateFormat formatter;
  static Directory appDocumentsDirectory;

  static Future getFilepath() async{
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
    new Directory('${staticfunction.appDocumentsDirectory.path}/DataSource').create();
    return appDocumentsDirectory;
  }

  static String getcurrencyformat(String amount){
    return currencyformatter.format(int.parse(amount));
  }

  static String getcurrencyformatInt(int amount){
    return currencyformatter.format(amount);
  }

  static String getdateformat(DateTime date){
    String formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    return formatted;
  }

  static String getfilename(DateTime date){
    String formatted = DateFormat('yyyy-MM').format(date);
    return formatted;
  }
}