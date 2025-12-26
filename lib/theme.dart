import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double defaultMargin = 24.0;

Color primaryColor = Color(0xFF3F7396);
Color secondaryColor = Color(0xFF4F8EB5);
Color tertiaryColor = Color(0xFF77BDDF);
Color quaternaryColor = Color(0xFFA4E2F9);
Color whiteColor = Color(0xFFFFFFFF);

LinearGradient customGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.0, 0.68, 0.96], // Stop points sesuai gambar
  colors: [
    secondaryColor,   
    tertiaryColor,    
    quaternaryColor,  
  ],
);

TextStyle primaryTextStyle = GoogleFonts.poppins(
  color: primaryColor,
  fontWeight: FontWeight.w700,
);
TextStyle whiteTextStyle = GoogleFonts.poppins(
  color: whiteColor,
  fontWeight: FontWeight.w700,
);

TextStyle whiteRegularTextStyle = GoogleFonts.poppins(
  color: whiteColor,
  fontWeight: FontWeight.w400,
);

TextStyle secondaryTextStyle = GoogleFonts.poppins(
  color: primaryColor,
  fontWeight: FontWeight.w400,
);