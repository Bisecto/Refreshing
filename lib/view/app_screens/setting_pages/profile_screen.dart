import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            // Back button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      // Handle back button press
                    },
                  ),
                ),
                TextStyles.textHeadings(textValue: 'Profile',textSize: 20),SizedBox()
              ],
            ),
            SizedBox(height: 20),
            // Profile Avatar with Edit Icon
            BlocBuilder<AuthBloc, AuthState>(

              builder: (context, state) {
                String userName='' ;
                String userEmail ='';
                String userPhone ='';
                String firstname='' ;
                String lastname ='';
               // String profileImage='' ;

                if (state is AuthAuthenticated) {
                  userName = state.user.username ??'User';
                  userEmail = state.user.email ?? 'user@example.com';
                  userPhone = state.user.phoneNumber ?? '';
                  firstname = state.user.firstName??'' ;
                  lastname = state.user.lastName??"";
                  // profileImage =
                  //     state.user.profileImage ??   'User';
                }

                return Container(
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.purple.shade100,
                            child: Text(
                              userName.substring(0,1),
                              style: TextStyle(fontSize: 40, color: Colors.black),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            top: 65,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: IconButton(
                                color: Colors.transparent,
                                icon: Icon(Icons.camera_alt, color: Colors.black),
                                onPressed: () {
                                  // Handle avatar image update
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Profile Name
                      Text(
                        '$lastname $firstname',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@ $userName',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      // Personal Information Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Email Row
                      buildInfoRow('Email', userEmail),
                      SizedBox(height: 20),
                      // Phone Number Row
                      buildInfoRow('Phone Number', userPhone),
                      SizedBox(height: 20),
                      // Date Joined Row
                      // buildInfoRow('Date Joined', dateJoined),
                      Spacer(),
                      // Update Button
                      FormButton(onPressed: (){},text: 'Update',bgColor: AppColors.appMainColor,),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),

           
          ],
        ),
      ),
    );
  }

  // Function to create info row with edit icon
  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Handle edit action for each row
          },
        ),
      ],
    );
  }

}


