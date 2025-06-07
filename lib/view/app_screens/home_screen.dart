import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:refreshing_co/res/app_images.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';
import 'package:refreshing_co/view/widgets/form_input.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_colors.dart';
import '../../res/app_icons.dart';
import 'home_screen_pages/app_bar.dart';
import 'home_screen_pages/cafe_list.dart';
import 'home_screen_pages/filtering_items.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onPageChanged;

  const HomeScreen({super.key, required this.onPageChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder:
  //           (context) => AlertDialog(
  //             backgroundColor: Colors.white,
  //             contentPadding: EdgeInsets.zero,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             content: Padding(
  //               padding: const EdgeInsets.all(5.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Align(
  //                       alignment: Alignment.topLeft,
  //                       child: Container(
  //                         height: 140,
  //                         width: 300,
  //                         decoration: BoxDecoration(
  //                           color: Colors.transparent,
  //                           // border: Border.all(color: AppColors.green),
  //                           image: DecorationImage(
  //                             image: AssetImage(AppImages.discount),
  //                             fit: BoxFit.cover,
  //                           ),
  //                           borderRadius: BorderRadius.circular(5),
  //                         ),
  //                         child: Align(
  //                           alignment: Alignment.topRight,
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(10.0),
  //                             child: Icon(
  //                               Icons.cancel_outlined,
  //                               color: AppColors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 5),
  //                   TextStyles.textHeadings(
  //                     textValue: "Get 10% off your first order",
  //                     textColor: AppColors.black,
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(0),
  //                     child: CustomText(
  //                       text:
  //                           "Explore a variety of cafes near you, "
  //                           "from trendy coffee bars to charming,"
  //                           " quiet spaces. Your perfect coffee "
  //                           "experience is just a tap away.",
  //                       color: AppColors.black,
  //                       size: 13,
  //                       maxLines: 5,
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                   FormButton(onPressed: () {Navigator.pop(context);},bgColor: AppColors.appMainColor,text: "Explore",borderRadius: 15,),
  //                 ],
  //               ),
  //             ),
  //           ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [

                Image.asset(AppImages.refresh, height: 70, width: 150),
                BlocBuilder<AuthBloc, AuthState>(

                  builder: (context, state) {
                    String userName='' ;
                    String userEmail ='';
                    String userPhone ='';
                    String firstname='' ;
                    String lastname ='';
                    // String profileImage='' ;
                    Placemark? placemark;

                    if (state is AuthAuthenticated) {
                      userName = state.user.username ??'User';
                      userEmail = state.user.email ?? 'user@example.com';
                      userPhone = state.user.phoneNumber ?? '';
                      firstname = state.user.firstName??'' ;
                      lastname = state.user.lastName??"";
                      placemark = state.placemark;
                      // profileImage =
                      //     state.user.profileImage ??   'User';
                    }

                    return CustomAppBar(placemark!);
                  },
                ),



                Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: CafeList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget CustomAppBar(Placemark placemark){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined,size: 25,),
                SizedBox(
                  width: 5,
                ),
                TextStyles.textHeadings(textValue: placemark.locality!),

              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.notification,
                  height: 25,
                  width: 25,
                ),SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: (){
                    widget.onPageChanged(1);
                  },
                  child: SvgPicture.asset(
                    AppIcons.bag,
                    height: 25,
                    width: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
