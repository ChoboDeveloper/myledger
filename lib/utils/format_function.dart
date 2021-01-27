import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class formatfunction{
  static final NumberFormat currencyformatter = NumberFormat("#,###");
  static DateFormat formatter;
  static Directory appDocumentsDirectory;

  static Future getFilepath() async{
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
    new Directory('${formatfunction.appDocumentsDirectory.path}/DataSource').create();
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

  static String getTimeformat(DateTime date){
    String formatted = DateFormat('hh:mm:ss').format(date);
    if(date.hour >= 12)
      formatted = '오후 ' + formatted;
    else
      formatted = '오전 ' + formatted;
    return formatted;
  }

  static String getdateformat_withtime(DateTime date){
    String tmp;
    String formatted;
    if(date.hour >= 12)
      tmp = '   오후';
    else
      tmp = '   오전';

    formatted = DateFormat('yyyy-MM-dd $tmp hh:mm:ss').format(date);
    return formatted;
  }
}