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
import 'package:ainotes/app/modules/ai_tool_create/controller/ai_tool_create_controller.dart';

class AiToolCreateView extends GetView<AiToolCreateController> {
  const AiToolCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CustomAppBar(
        color: Theme.of(context).colorScheme.secondaryContainer,
        centerTitle: true,
        title: CustomText(
          text: controller.title!,
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
            CustomContainer(
              height: height * 0.65,
              width: double.infinity,
              containerChild: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SingleChildScrollView(
                  child: Text(
                    controller.aiToolsResponse!.toString(),
                  ),
                ),
              ),
            ),
            Spacer(),
            FloatingActionButton.extended(
              backgroundColor: ColorCodes.teal,
              onPressed: () {
                /// copy to clip board message
                Clipboard.setData(
                  ClipboardData(
                    text: controller.aiToolsResponse!,
                  ),
                ).then(
                  (_) {
                    Fluttertoast.showToast(msg: 'Copied to your clipboard !');
                  },
                );
              },
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: CustomText(
                  text: AppConstants.copy,
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
