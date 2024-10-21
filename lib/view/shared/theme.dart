import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 20.0;
double defaultRadius = 10.0;

Color kPrimaryColor = const Color(0xffF38851);
Color kPrimaryLightColor = const Color(0xffF9F2ED);
Color kPrimaryLight2Color = const Color(0xffEDD6C8);
Color kSecondaryColor = const Color(0xff45301F);
Color kSecondary2Color = const Color(0xffC67C4E);
Color kSecondary3Color = const Color(0xff25180F);

Color kWhiteColor = const Color(0xffFFFFFF);
Color kBlackColor = const Color(0xff000000);
Color kGreyColor = const Color(0xff7E7E7E);
Color kYellowColor = const Color(0xffFBBE21);
Color kLightGreyColor = const Color(0xffEBEBEB);
Color kGreenColor = const Color(0xff29CB9E);
Color kRedColor = const Color.fromARGB(255, 243, 57, 113);
Color kTextColor = const Color(0xff313131);

TextStyle lightTextStyle =
    GoogleFonts.plusJakartaSans(color: kTextColor, fontWeight: light);

TextStyle regularTextStyle =
    GoogleFonts.plusJakartaSans(color: kTextColor, fontWeight: regular);

TextStyle mediumTextStyle =
    GoogleFonts.plusJakartaSans(color: kTextColor, fontWeight: medium);

TextStyle semiBoldTextStyle =
    GoogleFonts.plusJakartaSans(color: kTextColor, fontWeight: semiBold);

TextStyle boldTextStyle =
    GoogleFonts.plusJakartaSans(color: kTextColor, fontWeight: bold);

TextStyle extraBoldTextStyle =
    GoogleFonts.plusJakartaSans(color: kTextColor, fontWeight: extraBold);

TextStyle blackTextStyle =
    GoogleFonts.plusJakartaSans(color: kTextColor, fontWeight: black);

TextStyle whiteTextStyle = GoogleFonts.plusJakartaSans(
  color: kWhiteColor,
);

TextStyle greyTextStyle = GoogleFonts.plusJakartaSans(
  color: kGreyColor,
);

TextStyle greenTextStyle = GoogleFonts.plusJakartaSans(
  color: kGreenColor,
);

TextStyle redTextStyle = GoogleFonts.plusJakartaSans(
  color: kRedColor,
);

TextStyle purpleTextStyle = GoogleFonts.plusJakartaSans(
  color: kPrimaryColor,
);

FontWeight light = FontWeight.w200;
FontWeight regular = FontWeight.w500;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

var preloader = Center(child: CircularProgressIndicator(color: kPrimaryColor));
