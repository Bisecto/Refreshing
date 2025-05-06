import 'package:flutter/material.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe.dart';

import '../../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class CafeList extends StatelessWidget {
  CafeList({super.key});

  final List<String> sessions = [
    'Revival Cafe 1',
    'Revival Cafe 2',
    'Revival Cafe 3',
    'Revival Cafe 4',
    'Revival Cafe 4',
    'Revival Cafe 4',
    'Revival Cafe 4',
    'Revival Cafe 4',
    'Revival Cafe 3',
    'Revival Cafe 4',
    'Revival Cafe 4',
    'Revival Cafe 4',
    'Revival Cafe 4',
    'Revival Cafe 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sessions.length * 351,
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
              child:
                  SessionContainer(session: sessions[index], context: context));
        },
      ),
    );
  }

  Widget SessionContainer({required String session, required context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 335,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
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
                      image: AssetImage(
                        AppImages.cafeImg,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
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
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextStyles.textHeadings(textValue: session, textSize: 18),
                    const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.yellow,
                          size:15,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColors.yellow,
                          size:15,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColors.yellow,
                          size:15,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColors.yellow,
                          size:15,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColors.grey,
                          size:15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.red,
                    ),
                    CustomText(text: 'Dublin,ireland', size: 14),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: AppUtils.deviceScreenSize(context).width / 2.5,
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
                          Icon(
                            Icons.timer_outlined,
                            color: AppColors.green,
                          ),
                          CustomText(
                            text: '  Est. order time:5minutes',
                            size: 14,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: const SingleCafe());
                      },
                      child: Container(
                        height: 50,
                        width: AppUtils.deviceScreenSize(context).width / 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.appMainColor,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.15),
                          //     spreadRadius: 0,
                          //     blurRadius: 10,
                          //     offset: const Offset(0, 4),
                          //   ),
                          // ],

                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: 'View Menu',
                            size: 16,
                            maxLines: 3,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
