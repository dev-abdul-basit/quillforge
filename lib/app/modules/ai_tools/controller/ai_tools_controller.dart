import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/lists/ai_tools_list.dart';

import '../../../common/constants/app_strings.dart';

class AiToolsController extends GetxController {
  String selectedFilter = AppStrings.kAll;

  List<String> filter = [
    AppStrings.kAll,
    AppStrings.kWebsite,
    AppStrings.kMarketing,
    AppStrings.kContent,
    AppStrings.kSocial,
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  List get filteredAiTools {
    if (selectedFilter == AppStrings.kAll) {
      return aiTools;
    } else {
      return aiTools
          .where(
            (item) => item['Category'] == selectedFilter,
          )
          .toList();
    }
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    update();
  }
}
