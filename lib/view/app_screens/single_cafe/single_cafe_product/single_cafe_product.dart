import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe_product/selecting_choice.dart';

import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class SingleCafeProduct extends StatefulWidget {
  const SingleCafeProduct({super.key});

  @override
  State<SingleCafeProduct> createState() => _SingleCafeProductState();
}

class _SingleCafeProductState extends State<SingleCafeProduct> {
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
                  image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYOdDjHm0xP85-IG91igaKUL3w4T7zClpGNA&s',
                  ),
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
                                textValue: 'Hazelnut Cappuccino',
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
              padding: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: TextStyles.textHeadings(
                  textValue: 'Hazelnut Cappuccino', textSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: Row(
                children: [

                  CustomText(text: 'Milk', size: 16,color: AppColors.textColor,),
                  SizedBox(width: 5,),
                  CustomText(text: 'Chocolate', size: 16,color: AppColors.textColor,),
                  SizedBox(width: 5,),

                  CustomText(text: 'Ice', size: 16,color: AppColors.textColor,),

                ],
              ),
            ),
             Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: TextStyles.textHeadings(
                  textValue: 'Description', textSize: 20),
            ),
             Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
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
            SelectChoice(selecteditem: (String value) {  }, items: const ['Size','Regular','Small','Large'],),
            SelectChoice(selecteditem: (String value) {  }, items: const ['Sugar','Less','Normal','None'],),
            SelectChoice(selecteditem: (String value) {  }, items: const ['Ice','Less','None','Normal'],),
             Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,color: Colors.blue[700]),
                      TextStyles.richTexts(text1:'Revival Cafe and',text2:" 4 others",color2: Colors.blue[700]),

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(height: 20,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 15, 0, 0),
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
              padding: EdgeInsets.fromLTRB(20.0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextStyles.textHeadings(textValue: 'Available Locations', textSize: 20),
                  SvgPicture.asset(AppIcons.tag)
                  //Icon(Icons.)
                ],
              ),
            ),
             Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10, 20, 0),
              child: SizedBox(
                height: 5 * 170,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuContainer('Central Station',
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
      padding: const EdgeInsets.fromLTRB(1.0, 0, 10, 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.textHeadings(textValue: name),
                  SizedBox(
                    width: AppUtils.deviceScreenSize(context).width / 2,
                    child: TextStyles.textDetails(
                        textValue: desc,
                        textColor: AppColors.textColor,
                        textSize: 16),
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
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  // Set background color to black
                                  shape: BoxShape
                                      .circle, // Make the button circular
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.remove),
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
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  // Set background color to black
                                  shape: BoxShape
                                      .circle, // Make the button circular
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.add),
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
