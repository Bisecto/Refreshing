import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe.dart';

import '../../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_input.dart';

class CafeList extends StatelessWidget {
  CafeList({super.key});

  final List<String> sessions = [
    'ROBOT BARISTA BAR',
    'Hot food machine',
    'Revival Cafe 3',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
    // 'Revival Cafe 3',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
    // 'Revival Cafe 4',
  ];
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          hint: 'Search Location, Meals and more....',
          label: '',
          controller: _searchController,
          borderColor: AppColors.textFormFieldBackgroundColor,
          backgroundColor: AppColors.textFormFieldBackgroundColor,
          widget: Icon(Icons.search),

          //validator: AppValidator.validateTextfield,
        ),
        SizedBox(height: 10),
        TextStyles.textHeadings(textValue: "Around You", textSize: 18),
        SizedBox(height: 10),

        Container(
          height: sessions.length * 320,
          child: ListView.builder(
            itemCount: sessions.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  //AppNavigator.pushAndStackPage(context, page: SingleSessionResult(session: sessions[index], isBackKey: true,
                  //   )
                  //   );
                },
                child: SessionContainer(
                  session: sessions[index],
                  context: context,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget SessionContainer({required String session, required context}) {
    return GestureDetector(
      onTap: (){
            AppNavigator.pushAndStackPage(
              context,
              page: const SingleCafe(),
            );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 180,
                  width: AppUtils.deviceScreenSize(context).width,
                  decoration: BoxDecoration(
                    //color: AppColors.red,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.15),
                    //     spreadRadius: 0,
                    //     blurRadius: 10,
                    //     offset: const Offset(0, 4),
                    //   ),
                    // ],
                    image: const DecorationImage(
                      image: AssetImage(AppImages.cafeImg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 15, 0, 0),
                        child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: TextStyles.textSubHeadings(
                              textValue: '30% off',
                              textColor: AppColors.white,
                              textSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all( 7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextStyles.textHeadings(textValue: session, textSize: 18),
                     SvgPicture.asset(AppIcons.save)
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.red),
                      CustomText(text: 'Belfast City, UK', size: 14),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.yellow, size: 15),
                          CustomText(text: "4",),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: AppUtils.deviceScreenSize(context).width / 2,
                        decoration: BoxDecoration(
                          //color: AppColors.red,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.15),
                          //     spreadRadius: 0,
                          //     blurRadius: 10,
                          //     offset: const Offset(0, 4),
                          //   ),
                          // ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.timer_outlined, color: AppColors.green),
                            CustomText(
                              text: '  Est. order time:5minutes',
                              size: 14,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
