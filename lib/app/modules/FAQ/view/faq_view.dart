import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/modules/FAQ/controller/faq_controller.dart';

import '../../../common/constants/app_strings.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});

  // Parse FAQ string into list of Q&A pairs
  List<Map<String, String>> get faqItems {
    const faqString =
        "Q: What is QuillForge?\nA: QuillForge is an AI-powered productivity app that helps you create, edit, and organize notes using intelligent writing and content-generation tools.\n\n"
        "Q: How do AI Notes work in QuillForge?\nA: QuillForge uses advanced AI models to understand your input and generate structured, clear, and useful notes based on your intent.\n\n"
        "Q: What are the benefits of using QuillForge?\nA: QuillForge saves time by automating note creation, improving clarity, and helping you manage ideas, tasks, and content more efficiently.\n\n"
        "Q: Can QuillForge be used for different types of content?\nA: Yes, QuillForge supports meetings, study notes, brainstorming, social posts, marketing content, and many other use cases.\n\n"
        "Q: Is QuillForge easy to use?\nA: Yes, QuillForge is designed with a simple and intuitive interface, allowing you to generate and manage content with minimal effort.\n\n"
        "Q: Does QuillForge include tools beyond note-taking?\nA: Yes, QuillForge includes a library of AI tools for writing, marketing, social media, and productivity tasks.\n\n"
        "Q: Is my data secure in QuillForge?\nA: Yes, QuillForge takes data privacy seriously and applies security best practices to protect your notes and personal information.\n\n"
        "Q: How do I get started with QuillForge?\nA: Download the app, complete the onboarding process, and start creating AI-powered notes and content right away.";

    final items = <Map<String, String>>[];
    final pairs = faqString.split('\n\n');

    for (final pair in pairs) {
      final lines = pair.split('\n');
      if (lines.length >= 2) {
        final question = lines[0].replaceFirst('Q: ', '');
        final answer = lines[1].replaceFirst('A: ', '');
        items.add({'question': question, 'answer': answer});
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: _buildFaqList(context, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isDark
                    ? null
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.back,
                size: 20,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.kFAQ,
                  style: TextStyle(
                    fontFamily: poppins,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqList(BuildContext context, bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: faqItems.length,
      itemBuilder: (context, index) {
        return _FaqItem(
          question: faqItems[index]['question'] ?? '',
          answer: faqItems[index]['answer'] ?? '',
          isDark: isDark,
          index: index,
        );
      },
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool isDark;
  final int index;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.isDark,
    required this.index,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: widget.isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          childrenPadding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColorCodes.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${widget.index + 1}',
                style: TextStyle(
                  fontFamily: poppins,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ColorCodes.purple,
                ),
              ),
            ),
          ),
          title: Text(
            widget.question,
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: widget.isDark ? Colors.white : Colors.black87,
            ),
          ),
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: _isExpanded ? 0.5 : 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? ColorCodes.purple.withOpacity(0.1)
                    : (widget.isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.withOpacity(0.08)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                CupertinoIcons.chevron_down,
                size: 14,
                color: _isExpanded
                    ? ColorCodes.purple
                    : (widget.isDark ? Colors.white54 : Colors.black45),
              ),
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorCodes.purple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontFamily: poppins,
                  fontSize: 14,
                  height: 1.6,
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}