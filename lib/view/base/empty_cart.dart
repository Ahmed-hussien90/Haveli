import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/view/screens/home.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(child: SvgPicture.asset(
            "assets/images/groce.svg",height: Get.height * 0.5,
          )),
          Text(
            "Empty cart".tr,
            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.deepOrange),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: () {
                Get.back();
                Get.to(const MyHomePage());
              },
              child: Text(
                "Start Shopping".tr,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ))
        ],
      ),
    );
  }
}
