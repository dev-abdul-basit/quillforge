import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/FAQ/controller/faq_controller.dart';

import '../../../common/constants/app_strings.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: CommonText(
          text: AppStrings.kFAQ,
          fontFamily: poppinsSemiBold,
          fontColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: SingleChildScrollView(
          child: Text(
            KFAQString,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
