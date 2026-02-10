import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/lists/ai_tools_list.dart';
import 'package:ainotes/app/common/lists/ai_tools_list.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/ai_tools/controller/ai_tools_controller.dart';
import 'package:ainotes/app/routes/app_pages.dart';

import '../../../common/constants/app_strings.dart';

class AiToolsView extends GetView<AiToolsController> {
  const AiToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CommonAppBar(
        elevation: 1,
        shadowColor: ColorCodes.grey,
        //color: Theme.of(context).colorScheme.secondaryContainer,
        surfaceTintColor: ColorCodes.background,
        centerTitle: false,
        title: const CommonText(
          text: AppStrings.aiTools,
          fontFamily: poppinsSemiBold,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  GetBuilder<AiToolsController>(
                    builder: (controller) {
                      return Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  controller.selectedFilter != AppStrings.kAll
                                      ? controller.selectedFilter
                                      : aiTools[index]["Category"] ?? '',
                                  style:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: poppinsSemiBold,
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller
                                      .filteredAiTools[index]["SubCategory"]
                                      .length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 100,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, subIndex) {
                                    var subCategory =
                                        controller.filteredAiTools[index]
                                            ["SubCategory"][subIndex];

                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          Routes.aiToolsResponseView,
                                          arguments: {
                                            "title": controller
                                                        .filteredAiTools[index]
                                                    ["SubCategory"][subIndex]
                                                ["Title"],
                                            "info": controller
                                                        .filteredAiTools[index]
                                                    ["SubCategory"][subIndex]
                                                ["Info"],
                                            "prompt": controller
                                                        .filteredAiTools[index]
                                                    ["SubCategory"][subIndex]
                                                ["prompt"],
                                            "category": controller
                                                    .filteredAiTools[index]
                                                ["Category"],
                                            "language": subCategory["language"],
                                            "subheadings":
                                                subCategory["subheadings"],
                                            "keywords": subCategory["keywords"],
                                            "length": subCategory["length"],
                                            "product": subCategory["product"],
                                            "description":
                                                subCategory["description"],
                                            // "audience": subCategory["audience"],
                                            "tone": subCategory["tone"],
                                            "name": subCategory["name"],
                                            "titled": subCategory["title"],
                                            "company": subCategory["company"],
                                            "subject": subCategory["subject"],
                                            "position": subCategory["position"],
                                            "domains": subCategory["domains"],
                                            "content": subCategory["content"],
                                          },
                                        );
                                      },
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              width: 0.3,
                                              color: ColorCodes.purple
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    GetBuilder<
                                                        AiToolsController>(
                                                      builder: (controller) {
                                                        return Expanded(
                                                          child: Text(
                                                            controller.filteredAiTools[index]
                                                                            [
                                                                            "SubCategory"]
                                                                        [
                                                                        subIndex]
                                                                    ["Title"] ??
                                                                '',
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  poppinsSemiBold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    controller.filteredAiTools[
                                                                        index][
                                                                    "SubCategory"]
                                                                [
                                                                subIndex]["image"] !=
                                                            null
                                                        ? Container(
                                                            width: 27,
                                                            child: Image.asset(
                                                              controller.filteredAiTools[index]
                                                                              [
                                                                              "SubCategory"]
                                                                          [
                                                                          subIndex]
                                                                      [
                                                                      "image"] ??
                                                                  '',
                                                              width: 23,
                                                              height: 23,
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Text(
                                                  controller.filteredAiTools[
                                                                  index]
                                                              ["SubCategory"]
                                                          [subIndex]["Info"] ??
                                                      '',
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSurface
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox();
                          },
                          itemCount: controller.filteredAiTools.length,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GetBuilder<AiToolsController>(
              builder: (controller) {
                return Container(
                  height: 60,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.filter.length,
                      itemBuilder: (context, index) {
                        int decrementIndex = index - 1;

                        return GestureDetector(
                          onTap: () => controller.setFilter(
                            controller.filter[index],
                          ),
                          child: CommonContainer(
                            height: 40,
                            radius: 20,
                            borderWidth: 0,
                            containerMargin: const EdgeInsets.only(right: 10),
                            backgroundColor: controller.selectedFilter ==
                                    controller.filter[index]
                                ? ColorCodes.purple
                                : ColorCodes.greyLight,
                            containerChild: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    CommonText(
                                      text: controller.filter[index],
                                      fontFamily: poppins,

                                      //fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontColor: controller.selectedFilter ==
                                              controller.filter[index]
                                          ? Colors.white
                                          : ColorCodes.primary,
                                    ),
                                    index == 0
                                        ? CommonText(
                                            text: '',
                                          )
                                        : CommonText(
                                            text:
                                                " [${aiTools[decrementIndex]["SubCategory"].length.toString()}]",
                                            fontFamily: poppins,
                                            fontSize: 16,
                                            fontColor:
                                                controller.selectedFilter ==
                                                        controller.filter[index]
                                                    ? Colors.white
                                                    : ColorCodes.primary,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
