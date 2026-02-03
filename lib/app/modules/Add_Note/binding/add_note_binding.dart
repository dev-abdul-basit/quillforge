import 'package:get/get.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';

class AddNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddNoteController(),
    );
  }
}
