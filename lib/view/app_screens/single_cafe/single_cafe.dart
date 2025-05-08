import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe_product/single_cafe_product.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';

class SingleCafe extends StatefulWidget {
  const SingleCafe({super.key});

  @override
  State<SingleCafe> createState() => _SingleCafeState();
}

class _SingleCafeState extends State<SingleCafe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 350,
              width: AppUtils.deviceScreenSize(context).width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.singleProduct),
                  fit: BoxFit.fill,
                ),
                //shape: BoxShape.circle,
              ),
              child: Container(
                height: 350,
                width: AppUtils.deviceScreenSize(context).width,
                color: AppColors.black.withOpacity(0.5),
                child: Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TextStyles.textHeadings(
                                textValue: 'Revival Cafe',
                                textSize: 20,
                                textColor: AppColors.white),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.share,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: TextStyles.textHeadings(
                  textValue: 'Revival Cafe', textSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.black,
                  ),
                  CustomText(text: 'Dublin', size: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: TextStyles.textHeadings(
                  textValue: 'Description', textSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
              child: TextStyles.textDetails(
                  textValue:
                      'A cozy spot for coffee enthusiasts with a difference '
                      'find these specific cuts, opt for regular cuts but '
                      'ask the butcher to trim off the excess fat, or '
                      'do so yourself before cooking.',
                  textSize: 16,
                  textColor: AppColors.textColor),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.yellow,
                        size: 15,

                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.yellow,
                        size: 15,

                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.yellow,
                        size: 15,

                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.yellow,
                        size: 15,

                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.grey,
                        size: 15,

                      ),
                    ],
                  ),
                  CustomText(
                    text: "(40)",
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      TextStyles.textHeadings(textValue: '4  ', textSize: 20),
                      TextStyles.textSubHeadings(
                          textValue: 'Cuisines available',
                          textSize: 16,
                          textColor: AppColors.textColor),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 15, 0, 0),
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: TextStyles.textSubHeadings(
                                textValue: '30% off',
                                textColor: AppColors.white,
                                textSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextStyles.textHeadings(textValue: 'Menu', textSize: 20),
                  SvgPicture.asset(AppIcons.tag)
                  //Icon(Icons.)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
              child: SizedBox(
                height: 5 * 170,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuContainer('Hazelnut Cappuccino',
                        'Nutty and sweet flavor to  spice up the bold espresso..');
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget MenuContainer(String name, String desc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 0, 0, 10),
      child: GestureDetector(
        onTap: (){
          AppNavigator.pushAndStackPage(context, page: const SingleCafeProduct());
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 115,
                  width: 115,
                  decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                          image: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYOdDjHm0xP85-IG91igaKUL3w4T7zClpGNA&s',
                          ),
                          fit: BoxFit.fill)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextStyles.textHeadings(textValue: name,textSize: 15),
                    SizedBox(
                      width: AppUtils.deviceScreenSize(context).width / 2,
                      child: TextStyles.textDetails(
                          textValue: desc,
                          textColor: AppColors.textColor,
                          textSize: 13),
                    ),
                    const SizedBox(
                      width: 0,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.yellow,
                                size: 15,
                              ),
                            ],
                          ),
                          CustomText(
                            text: "(30)",
                          )
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: AppUtils.deviceScreenSize(context).width / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextStyles.textHeadings(textValue: '£2'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Minus button with black background
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    // Set background color to black
                                    shape: BoxShape
                                        .circle, // Make the button circular
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: _decrementCounter,
                                    color: Colors.white,
                                    iconSize: 15,
                                  ),
                                ),

                                // Display counter
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextStyles.textHeadings(
                                        textValue: '$_counter',
                                        textSize: 16,
                                        textColor: AppColors.black)),

                                // Add button with black background
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    // Set background color to black
                                    shape: BoxShape
                                        .circle, // Make the button circular
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: _incrementCounter,
                                      color: Colors.white,
                                      iconSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }
}
