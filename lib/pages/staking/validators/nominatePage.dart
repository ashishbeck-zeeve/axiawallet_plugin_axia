import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/nominateForm.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/txButton.dart';
import 'package:axiawallet_ui/pages/txConfirmPage.dart';

class NominatePage extends StatefulWidget {
  NominatePage(this.plugin, this.keyring);
  static final String route = '/staking/nominate';
  final PluginAxia plugin;
  final Keyring keyring;
  @override
  _NominatePageState createState() => _NominatePageState();
}

class _NominatePageState extends State<NominatePage> {
  Future<void> _setNominee(TxConfirmParams params) async {
    final res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: params);
    if (res != null) {
      Navigator.of(context).pop(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dicStaking =
        I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');

    return Scaffold(
      appBar: AppBar(
        title: Text(dicStaking['action.nominate']),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: NominateForm(
            widget.plugin,
            widget.keyring,
            onNext: (TxConfirmParams params) => _setNominee(params),
          ),
        );
      }),
    );
  }
}
