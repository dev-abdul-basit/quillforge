import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/sql/sql_helper.dart';

class FavouriteController extends GetxController {
  @override
  void onInit() {
    getFavorite();

    // TODO: implement onInit
    super.onInit();
  }

  void refreshFavoriteNote() {
    getFavorite();
    update();
  }

  /// Delete Note to SQL FLITE
  Future<void> deleteNote(int id) async {
    await SqlHelper.deleteNote(id);
    refreshFavoriteNote();
    homeController.deleteNote(id);
    update();
  }

  Future<List<Map<String, dynamic>>> getFavorite() async {
    final data = await SqlHelper.getFavoriteNotes();

    return data;
  }

  Future<void> toggleFavorite(int noteId, int favorite) async {
    if (favorite == 1) {
      await SqlHelper.unmarkAsFavorite(noteId);
      favorite = 0;
      Fluttertoast.showToast(msg: AppConstants.favouriteRemove);
      update();
    } else {
      await SqlHelper.markAsFavorite(noteId);

      favorite = 1;
      Fluttertoast.showToast(msg: AppConstants.favouriteAdd);
      update();
    }
    refreshFavoriteNote();
    homeController.refreshData();
  }
}
