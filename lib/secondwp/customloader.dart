import 'package:easy_loader/easy_loader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomLoader {
  showLoader() {
    EasyLoading.show(status: 'loading...');
  }

  dismisLoader() {
    EasyLoading.show(status: 'Fiinsh');
  }

  successLoader(String msg) {
    EasyLoading.showSuccess(msg);
  }

  ErrorLoader(String msg) {
    EasyLoading.showError(msg);
  }
}
