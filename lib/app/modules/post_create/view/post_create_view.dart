import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/post_create/controller/post_create_controller.dart';

import '../../../common/constants/app_strings.dart';

class PostCreateView extends GetView<PostCreateController> {
  const PostCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CommonAppBar(
        color: Theme.of(context).colorScheme.secondaryContainer,
        centerTitle: true,
        title: CommonText(
          text: controller.postType!,
          fontFamily: poppinsSemiBold,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            CommonContainer(
              height: height * 0.50,
              width: double.infinity,
              containerChild: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    controller.postResponse!.toString(),
                  ),
                ),
              ),
            ),
            Spacer(),
            FloatingActionButton.extended(
              backgroundColor: ColorCodes.purple,
              onPressed: () {
                /// copy to clip board message
                Clipboard.setData(
                  ClipboardData(
                    text: controller.postResponse!,
                  ),
                ).then(
                  (_) {
                    Fluttertoast.showToast(msg: 'Copied to your clipboard !');
                  },
                );
              },
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: CommonText(
                  text: AppStrings.copy,
                  fontColor: ColorCodes.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.10,
            ),
          ],
        ),
      ),
    );
  }
}
