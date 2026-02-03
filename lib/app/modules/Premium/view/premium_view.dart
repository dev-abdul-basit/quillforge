import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Premium/controller/premium_controller.dart';
import 'package:gradient_borders/gradient_borders.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorCodes.orange,
                ColorCodes.pink,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.010,
                ),
                CustomContainer(
                  height: 40,
                  width: 40,
                  backgroundColor: Colors.transparent,
                  borderWidth: 0,
                  radius: 60,
                  containerChild: IconButton(
                    color: const Color(0xff4E65FF),
                    splashColor: ColorCodes.teal,
                    iconSize: 20,
                    constraints:
                        const BoxConstraints(maxHeight: 40, maxWidth: 40),
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: ColorCodes.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                Center(
                  child: Image.asset(
                    premiumIcon,
                    color: ColorCodes.white,
                    width: 150.w,
                    height: 150.h,
                  ),
                ),
                const Center(
                  child: CustomText(
                    text: AppConstants.unlockPremium,
                    fontFamily: montserratRegular,
                    fontWeight: FontWeight.bold,
                    fontColor: ColorCodes.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    controller.type.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 7, bottom: 7, left: width * 0.14),
                        child: Row(
                          children: [
                            const CustomIcon(
                              icon: Icons.check_circle,
                              color: ColorCodes.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              child: CustomText(
                                text: controller.type[index],
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratRegular,
                                fontColor: ColorCodes.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                      // return ListTile(
                      //   dense: true,
                      //   minLeadingWidth: 10,
                      //   contentPadding: EdgeInsets.symmetric(
                      //       vertical: 0, horizontal: width * 0.12),
                      //   leading: CustomIcon(
                      //     icon: Icons.check_circle,
                      //     color: ColorCodes.white,
                      //     size: 19,
                      //   ),
                      //   title: CustomText(
                      //     text: controller.type[index],
                      //     fontWeight: FontWeight.bold,
                      //     fontFamily: montserratRegular,
                      //     fontColor: ColorCodes.white,
                      //     fontSize: 12,
                      //   ),
                      // );
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.055,
                ),
                Card(
                  elevation: 5,
                  child: CustomContainer(
                    width: double.infinity,
                    backgroundColor: ColorCodes.white,
                    borderColor: ColorCodes.white,
                    containerChild: GetBuilder<PremiumController>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 12),
                          child: SizedBox(
                            height: 105,
                            child: ListView.builder(
                              itemCount: controller.products.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => controller.onSelected(index),
                                  child: Container(
                                    width: 115.w,
                                    height: 110.h,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    decoration: BoxDecoration(
                                      color: controller.selected == index
                                          ? ColorCodes.white
                                          : ColorCodes.greyLight,
                                      border: GradientBoxBorder(
                                        gradient: LinearGradient(
                                          colors: controller.selected == index
                                              ? [
                                                  ColorCodes.orange,
                                                  ColorCodes.pink,
                                                ]
                                              : [
                                                  ColorCodes.white,
                                                  ColorCodes.white,
                                                ],
                                        ),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 18),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: CustomText(
                                              text: controller
                                                  .products[index].title
                                                  .replaceAll(
                                                      "(com.aichatbot.aichatbot (unreviewed))",
                                                      ""),
                                              fontWeight: FontWeight.bold,
                                              fontColor:
                                                  controller.selected == index
                                                      ? ColorCodes.black
                                                      : ColorCodes.black
                                                          .withOpacity(0.5),
                                              fontFamily: poppins,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          const Spacer(),
                                          CustomText(
                                            text: controller
                                                .products[index].price,
                                            maxLines: 1,
                                            fontWeight: FontWeight.bold,
                                            fontColor:
                                                controller.selected == index
                                                    ? ColorCodes.black
                                                    : ColorCodes.black
                                                        .withOpacity(0.5),
                                            fontFamily: poppins,
                                            fontSize: 20.sp,
                                          ),
                                        ],
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
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                Card(
                  elevation: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CustomContainer(
                    width: double.infinity,
                    borderWidth: 0,
                    radius: 30,
                    backgroundColor: ColorCodes.black,
                    containerChild: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 3),
                      child: CupertinoButton(
                        /// Buy Product
                        onPressed: () => controller.buy(),
                        borderRadius: BorderRadius.circular(0),
                        child: Center(
                          child: CustomText(
                            text: 'Continue',
                            fontWeight: FontWeight.bold,
                            fontColor: ColorCodes.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.010,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
