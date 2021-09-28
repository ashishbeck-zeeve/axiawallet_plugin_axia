import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/addressIcon.dart';
import 'package:axiawallet_ui/utils/format.dart';

class ControllerSelectPage extends StatelessWidget {
  ControllerSelectPage(this.plugin, this.keyring);
  final PluginAxia plugin;
  final Keyring keyring;

  static final String route = '/staking/account/list';

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          final dic =
              I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');
          return Scaffold(
            appBar: AppBar(
              title: Text(dic['controller']),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                color: Theme.of(context).cardColor,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: keyring.allAccounts.map((i) {
                    String unavailable;
                    final stashOf = plugin
                        .store.staking.accountBondedMap[i.pubKey].controllerId;
                    String controllerOf =
                        plugin.store.staking.accountBondedMap[i.pubKey].stashId;
                    if (stashOf != null && i.pubKey != keyring.current.pubKey) {
                      unavailable =
                          '${dic['controller.stashOf']} ${Fmt.address(stashOf)}';
                    }
                    if (controllerOf != null &&
                        controllerOf != keyring.current.address) {
                      unavailable =
                          '${dic['controller.controllerOf']} ${Fmt.address(controllerOf)}';
                    }
                    Color grey = Theme.of(context).disabledColor;
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 16),
                        color: Theme.of(context).cardColor,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: AddressIcon(i.address, svg: i.icon),
                            ),
                            Expanded(
                              child: unavailable != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          i.name,
                                          style: TextStyle(color: grey),
                                        ),
                                        Text(
                                          Fmt.address(i.address),
                                          style: TextStyle(color: grey),
                                        ),
                                        Text(
                                          unavailable,
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(i.name),
                                        Text(Fmt.address(i.address)),
                                      ],
                                    ),
                            ),
                            unavailable == null
                                ? Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      onTap: unavailable == null
                          ? () => Navigator.of(context).pop(i)
                          : null,
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      );
}
