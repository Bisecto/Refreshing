import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/view/app_screens/cart_app_bar/cart_app_bar.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';

import '../../../bloc/notification_setting_bloc/notification_settings_bloc.dart';
import '../../../bloc/notification_setting_bloc/notification_settings_event.dart';
import '../../../bloc/notification_setting_bloc/notification_settings_state.dart';

import '../../../model/notification/notification_setting.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Load notification settings when screen opens
    context.read<NotificationSettingsBloc>().add(LoadNotificationSettingsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: BlocListener<NotificationSettingsBloc, NotificationSettingsState>(
          listener: (context, state) {
            if (state is NotificationSettingsLoaded) {
              setState(() {
                _showSaveButton = state.hasUnsavedChanges;
              });
            } else if (state is NotificationSettingsSaved) {
              setState(() {
                _showSaveButton = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            } else if (state is NotificationSettingsUpdateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            } else if (state is NotificationSettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }
          },
          child: Column(
            children: [
              _buildHeader(),
              _buildWarningMessage(),
              _buildTabBar(),
              Expanded(
                child: BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
                  builder: (context, state) {
                    if (state is NotificationSettingsLoading) {
                      return _buildLoadingState();
                    }

                    if (state is NotificationSettingsLoaded) {
                      return _buildSettingsContent(state.settings);
                    }

                    if (state is NotificationSettingsSaving) {
                      return _buildSavingState();
                    }

                    // Try to show cached data on error
                    final settings = context.read<NotificationSettingsBloc>().currentSettings;
                    if (settings != null) {
                      return _buildSettingsContent(settings);
                    }

                    return _buildErrorState();
                  },
                ),
              ),
              if (_showSaveButton) _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _handleBackPress(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextStyles.textHeadings(
              textValue: 'Notification Settings',
              textSize: 24,
              textColor: Colors.black87,
            ),
          ),
          BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
            builder: (context, state) {
              if (state is NotificationSettingsLoaded && state.hasUnsavedChanges) {
                return GestureDetector(
                  onTap: () {
                    context.read<NotificationSettingsBloc>().add(ResetNotificationSettingsEvent());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWarningMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'We may still send you critical notifications outside your preferences for security and legal requirements.',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.appMainColor,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: AppColors.appMainColor,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'Orders'),
          Tab(text: 'Marketing'),
          Tab(text: 'Account'),
          Tab(text: 'Channels'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading settings...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Saving settings...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Failed to load settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<NotificationSettingsBloc>().add(LoadNotificationSettingsEvent());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appMainColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(NotificationSettingsModel settings) {
    return Column(
      children: [
        // Master toggle
        _buildMasterToggle(settings),

        const SizedBox(height: 16),

        // Tabbed content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderSettings(settings),
              _buildMarketingSettings(settings),
              _buildAccountSettings(settings),
              _buildChannelSettings(settings),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMasterToggle(NotificationSettingsModel settings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: const Text(
          'All Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          'Enable or disable all notification types',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        value: settings.allNotifications,
        activeColor: AppColors.appMainColor,
        onChanged: (value) {
          context.read<NotificationSettingsBloc>().add(
            UpdateAllNotificationsEvent(value: value),
          );
        },
      ),
    );
  }

  Widget _buildOrderSettings(NotificationSettingsModel settings) {
    return _buildSettingsList(settings.orderSettings, settings);
  }

  Widget _buildMarketingSettings(NotificationSettingsModel settings) {
    return _buildSettingsList(settings.marketingSettings, settings);
  }

  Widget _buildAccountSettings(NotificationSettingsModel settings) {
    final accountSettings = [
      ...settings.accountSettings,
      ...settings.subscriptionSettings,
    ];
    return _buildSettingsList(accountSettings, settings);
  }

  Widget _buildChannelSettings(NotificationSettingsModel settings) {
    return _buildSettingsList(settings.channelSettings, settings);
  }

  Widget _buildSettingsList(List<NotificationSetting> settingsList, NotificationSettingsModel settings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: settingsList.length,
      itemBuilder: (context, index) {
        final setting = settingsList[index];
        return _buildSettingCard(setting, settings);
      },
    );
  }

  Widget _buildSettingCard(NotificationSetting setting, NotificationSettingsModel settings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.appMainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            setting.icon,
            color: AppColors.appMainColor,
            size: 20,
          ),
        ),
        title: Text(
          setting.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            setting.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ),
        value: setting.value,
        activeColor: AppColors.appMainColor,
        onChanged: settings.allNotifications || setting.key == 'allNotifications'
            ? (value) {
          context.read<NotificationSettingsBloc>().add(
            UpdateNotificationSettingEvent(
              settingKey: setting.key,
              value: value,
            ),
          );
        }
            : null, // Disable if master toggle is off
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<NotificationSettingsBloc>().add(SaveNotificationSettingsEvent());
              },
              icon: const Icon(Icons.save, size: 20),
              label: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appMainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBackPress() {
    final bloc = context.read<NotificationSettingsBloc>();
    if (bloc.hasUnsavedChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved changes. Do you want to save them before leaving?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<NotificationSettingsBloc>().add(ResetNotificationSettingsEvent());
                Navigator.of(context).pop();
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<NotificationSettingsBloc>().add(SaveNotificationSettingsEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appMainColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}