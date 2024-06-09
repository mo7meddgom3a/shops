import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/core/spining_lines_loader.dart';
import 'package:flutter/material.dart';


Widget loadingIndicator({Color? color}){
  return Center(
    child: SpinningLinesLoader(
      color: color ?? ColorConstant.primaryColor,
      duration: const Duration(milliseconds: 3000),
      itemCount: 3,
      size: 50,
      lineWidth: 2,
    ),
  );
}