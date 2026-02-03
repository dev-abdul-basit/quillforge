import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';

class NoHistoryWidget extends StatelessWidget {
  const NoHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.15,
          ),
          Image.asset(
            noDataFoundImage,
            height: 150.h,
            width: 150.h,
          ),
          SizedBox(
            height: 20.h,
          ),
          const Center(
            child: Text(
              AppConstants.kNoHistory,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: montserratRegular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
