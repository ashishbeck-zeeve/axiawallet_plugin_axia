import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/bondPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/nominateForm.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/txButton.dart';
import 'package:axiawallet_ui/pages/txConfirmPage.dart';

class StakePage extends StatefulWidget {
  StakePage(this.plugin, this.keyring);
  static final String route = '/staking/stake';
  final PluginAxia plugin;
  final Keyring keyring;
  @override
  _StakePageState createState() => _StakePageState();
}

class _StakePageState extends State<StakePage> {
  /// staking action has 2 steps on this page:
  /// 0. staking.bond()
  /// 1. staking.nominate()
  int _step = 0;
  TxConfirmParams _bondParams;

  Future<void> _onStake(TxConfirmParams nominateParams) async {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'common');
    final txBond = 'api.tx.staking.bond(...${jsonEncode(_bondParams.params)})';
    final txNominate =
        'api.tx.staking.nominate(...${jsonEncode(nominateParams.params)})';
    final res = await Navigator.of(context).pushNamed(TxConfirmPage.route,
        arguments: TxConfirmParams(
          txTitle: dic['staking'],
          module: 'utility',
          call: 'batchAll',
          txDisplay: {
            "actions": [
              {
                'call': '${_bondParams.module}.${_bondParams.call}',
                ..._bondParams.txDisplay
              },
              {
                'call': '${nominateParams.module}.${nominateParams.call}',
                ...nominateParams.txDisplay
              }
            ],
          },
          params: [],
          rawParams: '[[$txBond,$txNominate]]',
        ));
    if (res != null) {
      Navigator.of(context).pop(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'common');

    return Scaffold(
      appBar: AppBar(
        title: Text('${dic['staking']} ${_step + 1}/2'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            if (_step == 1) {
              setState(() {
                _step = 0;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: _step == 0
              ? BondPage(
                  widget.plugin,
                  widget.keyring,
                  onNext: (TxConfirmParams bondParams) {
                    setState(() {
                      _bondParams = bondParams;
                      _step = 1;
                    });
                  },
                )
              : NominateForm(
                  widget.plugin,
                  widget.keyring,
                  onNext: (TxConfirmParams params) => _onStake(params),
                ),
        );
      }),
    );
  }
}
