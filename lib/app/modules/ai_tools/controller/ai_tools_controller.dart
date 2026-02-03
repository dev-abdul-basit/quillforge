import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/lists/ai_tools_list.dart';

class AiToolsController extends GetxController {
  String selectedFilter = AppConstants.kAll;

  List<String> filter = [
    AppConstants.kAll,
    AppConstants.kWebsite,
    AppConstants.kMarketing,
    AppConstants.kContent,
    AppConstants.kSocial,
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  List get filteredAiTools {
    if (selectedFilter == AppConstants.kAll) {
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
