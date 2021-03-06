// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/actions.dart';
import 'package:axiawallet_plugin_axia/pages/staking/validators/overview.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/plugin/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_ui/components/pageTitleTaps.dart';
import 'package:axiawallet_ui/components/cupertinoTabBar.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';

class Staking extends StatefulWidget {
  Staking(this.plugin, this.keyring);

  final AXIAWalletPlugin plugin;
  final Keyring keyring;

  @override
  _StakingState createState() => _StakingState();
}

class _StakingState extends State<Staking> {
  _StakingState();

  int _tab = 0;

  Widget title(String text, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
            color: selected ? Theme.of(context).primaryColor : Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');
    var tabs = [dic['actions'], dic['validators']];
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 16),
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            // PageTitleTabs(
            //   names: tabs,
            //   activeTab: _tab,
            //   onTab: (v) {
            //     if (_tab != v) {
            //       setState(() {
            //         _tab = v;
            //       });
            //     }
            //   },
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.white.withOpacity(0.5)),
              //   borderRadius: BorderRadius.all(
              //     Radius.circular(10),
              //   ),
              // ),
              child: CustomCupertinoTabBar(
                children: tabs,
                groupValue: _tab,
                onValueChanged: (int v) {
                  if (_tab != v) {
                    setState(() {
                      _tab = v;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: _tab == 1
                  ? StakingOverviewPage(widget.plugin, widget.keyring)
                  : StakingActions(widget.plugin, widget.keyring),
            ),
          ],
        ),
      ),
    );
  }
}
