import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/no_favourite_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/favourite/controller/favourite_controller.dart';
import 'package:ainotes/app/modules/home/widget/delete_note_dialogbox.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

import '../../../common/constants/app_strings.dart';

class FavouriteView extends GetView<FavouriteController> {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CommonAppBar(
        color: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        title: const CommonText(
          text: AppStrings.favourite,
          fontFamily: poppinsSemiBold,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            GetBuilder<FavouriteController>(
              builder: (controller) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: controller.getFavorite(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorCodes.purple,
                            ),
                          ),
                        );
                      } else {
                        return const SingleChildScrollView(
                          child: NoFavouriteWidget(),
                        );
                      }
                    } else {
                      final data = snapshot.data!;

                      /// DATA SHOW REVERSE
                      final reversedData = data.reversed.toList();
                      print("DATa $data");

                      return Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: reversedData.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 220,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            /// Change Date Formate
                            String createdAt =
                                reversedData[index]["createdAt"] ?? "";

                            DateTime dateTime =
                                DateFormat("EEE, M/d/yyyy hh:mm:ss a")
                                    .parse(createdAt);
                            String formattedDate =
                                DateFormat("EEE, yyyy/MM/dd hh:mm a")
                                    .format(dateTime);

                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.addNoteView,
                                  arguments: {
                                    "id": reversedData[index]["id"],
                                    "title": reversedData[index]["title"],
                                    "description": reversedData[index]
                                        ["description"],
                                    "isFavoriteScreen": true,
                                  },
                                );
                              },
                              child: Card(
                                elevation: 0.5,
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: ColorCodes.background,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 4,
                                      top: 4,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CommonText(
                                                text: reversedData[index]
                                                        ["title"] ??
                                                    "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: poppins,
                                                fontSize: 14,
                                                fontColor: ColorCodes.primary
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            GetBuilder<FavouriteController>(
                                              builder: (controller) {
                                                return Container(
                                                  width: 25,
                                                  height: 25,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      controller.toggleFavorite(
                                                          reversedData[index]
                                                              ["id"],
                                                          reversedData[index]
                                                              ["favorite"]);
                                                    },
                                                    icon: CommonmIcon(
                                                      icon: reversedData[index][
                                                                  "favorite"] ==
                                                              1
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      size: 18,
                                                      color: reversedData[index]
                                                                  [
                                                                  "favorite"] ==
                                                              1
                                                          ? ColorCodes.orange
                                                          : ColorCodes.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Container(
                                              width: 25,
                                              height: 25,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  deleteDialogBox(
                                                      onConfirm: () {
                                                        controller.deleteNote(
                                                            reversedData[index]
                                                                ["id"]);
                                                        Get.back();
                                                      },
                                                      titleText: AppStrings
                                                          .deleteNote);
                                                },
                                                icon: const CommonmIcon(
                                                  icon: Icons.delete,
                                                  size: 18,
                                                  color: ColorCodes.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Divider(
                                          height: 0,
                                          thickness: 0.4,
                                          endIndent: 6,
                                          color:
                                              ColorCodes.grey.withOpacity(0.5),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: CommonText(
                                            text: reversedData[index]
                                                    ["description"] ??
                                                "",
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: poppins,
                                            fontSize: 8,
                                            maxLines: 10,
                                            fontColor: ColorCodes.primary
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            CommonmIcon(
                                              icon: Icons
                                                  .access_time_filled_rounded,
                                              size: 12,
                                              color: ColorCodes.primary
                                                  .withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            // Container(
                                            //   width: 0.5,
                                            //   height: 10,
                                            //   color: ColorCodes.primary
                                            //       .withOpacity(0.3),
                                            // ),
                                            // SizedBox(
                                            //   width: 3.w,
                                            // ),
                                            CommonText(
                                              text: formattedDate.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: poppins,
                                              fontSize: 9.sp,
                                              maxLines: 1,
                                              fontColor: ColorCodes.primary
                                                  .withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
