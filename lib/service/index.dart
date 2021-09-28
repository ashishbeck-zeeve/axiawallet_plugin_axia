import 'package:flutter/cupertino.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/service/gov.dart';
import 'package:axiawallet_plugin_axia/service/staking.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/storage/types/keyPairData.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/passwordInputDialog.dart';
import 'package:axiawallet_ui/utils/i18n.dart';

class PluginApi {
  PluginApi(PluginAxia plugin, Keyring keyring)
      : staking = ApiStaking(plugin, keyring),
        gov = ApiGov(plugin, keyring),
        plugin = plugin;
  final ApiStaking staking;
  final ApiGov gov;

  final PluginAxia plugin;

  Future<String> getPassword(BuildContext context, KeyPairData acc) async {
    final password = await showCupertinoDialog(
      context: context,
      builder: (_) {
        return PasswordInputDialog(
          plugin.sdk.api,
          title: Text(
              I18n.of(context).getDic(i18n_full_dic_ui, 'common')['unlock']),
          account: acc,
        );
      },
    );
    return password;
  }

  Future<String> getRuntimeModuleName(List<String> modules) async {
    final res = await Future.wait(modules.map((e) => plugin.sdk.webView
        .evalJavascript('(api.tx.$e != undefined ? {} : null)',
            wrapPromise: false)));
    print(res);
    return modules[res.indexWhere((e) => e != null)];
  }
}
