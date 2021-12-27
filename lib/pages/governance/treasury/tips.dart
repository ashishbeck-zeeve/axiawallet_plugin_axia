import 'package:axiawallet_ui/components/animatedLoadingWheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:axiawallet_plugin_axia/pages/governance/treasury/tipDetailPage.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/api/types/gov/treasuryTipData.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/addressIcon.dart';
import 'package:axiawallet_ui/components/listTail.dart';
import 'package:axiawallet_ui/components/roundedCard.dart';
import 'package:axiawallet_ui/utils/index.dart';

class MoneyTips extends StatefulWidget {
  MoneyTips(this.plugin, this.keyring);
  final PluginAxia plugin;
  final Keyring keyring;

  @override
  _ProposalsState createState() => _ProposalsState();
}

class _ProposalsState extends State<MoneyTips> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = true;

  Future<void> _fetchData() async {
    widget.plugin.service.gov.updateBestNumber();
    await widget.plugin.service.gov.queryTreasuryTips();
    if (this.mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _refreshKey.currentState?.show();
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        final tips = List<TreasuryTipData>();
        if (widget.plugin.store.gov.treasuryTips != null) {
          tips.addAll(widget.plugin.store.gov.treasuryTips.reversed);
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            RefreshIndicator(
              key: _refreshKey,
              onRefresh: _fetchData,
              child: tips.length == 0
                  ? ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width / 2),
                          child: Center(
                              child: ListTail(
                            isEmpty: true,
                            isLoading: false,
                          )),
                        );
                      })
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 32),
                      itemCount: tips.length + 1,
                      itemBuilder: (_, int i) {
                        if (tips.length == i) {
                          return ListTail(
                            isEmpty: false,
                            isLoading: false,
                          );
                        }
                        return Observer(builder: (_) {
                          final TreasuryTipData tip = tips[i];
                          final icon = widget
                              .plugin.store.accounts.addressIconsMap[tip.who];
                          final indices = widget
                              .plugin.store.accounts.addressIndexMap[tip.who];
                          return RoundedCard(
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: ListTile(
                              leading: AddressIcon(
                                tip.who,
                                svg: icon,
                              ),
                              title: UI.accountDisplayName(tip.who, indices),
                              subtitle: Text(tip.reason),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(I18n.of(context).getDic(
                                      i18n_full_dic_axialunar,
                                      'gov')['treasury.tipper']),
                                  Text(
                                    tip.tips.length.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final res =
                                    await Navigator.of(context).pushNamed(
                                  TipDetailPage.route,
                                  arguments: tip,
                                );
                                if (res != null) {
                                  _refreshKey.currentState.show();
                                }
                              },
                            ),
                          );
                        });
                      },
                    ),
            ),
            _isLoading ? AnimatedLoadingWheel(alt: true) : Container()
          ],
        );
      },
    );
  }
}
