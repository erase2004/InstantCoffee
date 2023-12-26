import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/auth_provider.dart';
import 'package:readr_app/data/providers/local_storage_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:real_time_invoice_widget/data/provider/election_data_provider.dart';

import '../../data/providers/auth_api_provider.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.put(AuthApiProvider.instance);
    Get.put(AuthProvider.instance);
    Get.put(ArticlesApiProvider.instance);
    Get.put(LocalStorageProvider.instance);
    Get.put(ElectionDataProvider.create(Environment().config.electionPath));
  }
}
