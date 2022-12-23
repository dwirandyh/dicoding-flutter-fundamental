import 'package:dicoding_flutter_fundamental/pages/setting/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void notificationChanged(bool value) {
    Provider.of<SettingProvider>(context, listen: false).changeSetting(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: _settingOptions(),
    );
  }

  Widget _settingOptions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Restoran Baru",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Aktifkan notifikasi",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          Consumer<SettingProvider>(builder: (context, provider, _) {
            return Switch(
                value: provider.isNotificationActivated,
                onChanged: notificationChanged);
          }),
        ],
      ),
    );
  }
}
