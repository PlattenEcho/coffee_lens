import 'package:coffee_vision/controller/cubit.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomNavBarItem extends StatelessWidget {
  final int index;
  final String imageUrl;
  final String text;
  const CustomNavBarItem(
      {super.key,
      required this.index,
      required this.imageUrl,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PageCubit>().setPage(index);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            imageUrl,
            width: 24,
            height: 24,
            color: (context.read<PageCubit>().state == index)
                ? kSecondaryColor
                : kGreyColor,
          ),
          Text(
            text,
            style: context.read<PageCubit>().state == index
                ? semiBoldTextStyle.copyWith(
                    fontSize: 12, color: kSecondaryColor)
                : regularTextStyle.copyWith(fontSize: 12, color: kGreyColor),
          )
        ])),
      ),
    );
  }
}

class CustomNavBarItem2 extends StatelessWidget {
  final int index;
  final String imageUrl;
  const CustomNavBarItem2({
    super.key,
    required this.index,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PageCubit>().setPage(index);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Center(
            child: Container(
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Image.asset(imageUrl,
              width: 28, height: 28, color: kPrimaryColor),
        )),
      ),
    );
  }
}
