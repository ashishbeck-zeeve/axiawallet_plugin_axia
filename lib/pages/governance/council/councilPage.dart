import 'package:axiawallet_ui/components/CupertinoTabBar.dart';
import 'package:axiawallet_ui/components/animatedLoadingWheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/council.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/motions.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/ui.dart';
import 'package:axiawallet_ui/components/topTaps.dart';

class CouncilPage extends StatefulWidget {
  CouncilPage(this.plugin, this.keyring);
  final PluginAxia plugin;
  final Keyring keyring;

  static const String route = '/gov/council/index';

  @override
  _GovernanceState createState() => _GovernanceState();
}

class _GovernanceState extends State<CouncilPage> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.plugin.sdk.api.connectedNode == null) {
        return;
      }
      widget.plugin.service.gov.queryCouncilInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'gov');
    final tabs = [dic['council'], dic['council.motions']];
    return Scaffold(
      body: PageWrapperWithBackground(SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Theme.of(context).cardColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: CustomCupertinoTabBar(
                      children: tabs,
                      groupValue: _tab,
                      onValueChanged: (v) {
                        setState(() {
                          if (_tab != v) {
                            _tab = v;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  )
                ],
              ),
              Observer(
                builder: (_) {
                  return Expanded(
                    child: widget.plugin.store.gov.council.members == null
                        ? AnimatedLoadingWheel(alt: true)
                        : _tab == 0
                            ? Council(widget.plugin)
                            : Motions(widget.plugin),
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
