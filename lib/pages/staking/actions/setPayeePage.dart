import 'dart:convert';

import 'package:axiawallet_plugin_axia/common/constants.dart';
import 'package:axiawallet_ui/components/iosBackButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/api/types/staking/ownStashInfo.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/storage/types/keyPairData.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/addressFormItem.dart';
import 'package:axiawallet_ui/components/addressInputField.dart';
import 'package:axiawallet_ui/components/textTag.dart';
import 'package:axiawallet_ui/components/txButton.dart';

class SetPayeePage extends StatefulWidget {
  SetPayeePage(this.plugin, this.keyring);
  static final String route = '/staking/payee';
  final PluginAxia plugin;
  final Keyring keyring;
  @override
  _SetPayeePageState createState() => _SetPayeePageState();
}

class _SetPayeePageState extends State<SetPayeePage> {
  int _rewardTo;
  String _rewardAccount;

  Future<TxConfirmParams> _getTxParams() async {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');
    final rewardToOptions =
        PayeeSelector.options.map((i) => dic['reward.$i']).toList();
    final OwnStashInfoData currentPayee =
        widget.plugin.store.staking.ownStashInfo;

    if (_rewardTo == null) {
      bool noChange = false;
      if (currentPayee.destinationId != 3 || _rewardAccount == null) {
        noChange = true;
      } else if (currentPayee.destinationId == 3 &&
          currentPayee.destination.contains(_rewardAccount.toLowerCase())) {
        noChange = true;
      }
      if (noChange) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Container(),
              content: Text('${dic['reward.warn']}'),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(I18n.of(context)
                      .getDic(i18n_full_dic_axialunar, 'common')['ok']),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
        return null;
      }
    }

    final to = _rewardTo ?? currentPayee.destinationId;
    return TxConfirmParams(
      txTitle: dic['action.setting'],
      module: 'staking',
      call: 'setPayee',
      txDisplay: {
        "reward_destination":
            to == 3 ? {'Account': _rewardAccount} : rewardToOptions[to],
      },
      params: [
        // "to"
        to == 3 ? {'Account': _rewardAccount} : to,
      ],
    );
  }

  void _onPayeeChanged(int to, String address) {
    setState(() {
      _rewardTo = to;
      _rewardAccount = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['action.setting']),
        centerTitle: true,
        leading: IOSBackButton(),
      ),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: AddressFormItem(
                        widget.keyring.current,
                        label: dic['controller'],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: PayeeSelector(
                        widget.plugin,
                        widget.keyring,
                        initialValue: widget.plugin.store.staking.ownStashInfo,
                        onChange: _onPayeeChanged,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TxButton(
                  getTxParams: _getTxParams,
                  onFinish: (Map res) {
                    if (res != null) {
                      Navigator.of(context).pop(res);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class PayeeSelector extends StatefulWidget {
  PayeeSelector(this.plugin, this.keyring, {this.initialValue, this.onChange});

  static const options = ['Staked', 'Stash', 'Controller', 'Account'];

  final PluginAxia plugin;
  final Keyring keyring;
  final OwnStashInfoData initialValue;
  final Function(int, String) onChange;

  @override
  _PayeeSelectorState createState() => _PayeeSelectorState();
}

class _PayeeSelectorState extends State<PayeeSelector> {
  int _rewardTo;
  KeyPairData _rewardAccount;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');

    final rewardToOptions =
        PayeeSelector.options.map((i) => dic['reward.$i']).toList();

    KeyPairData defaultAcc = widget.keyring.current;
    if ((_rewardTo ?? widget.initialValue.destinationId) == 3) {
      if (widget.initialValue.destinationId == 3) {
        final acc = KeyPairData();
        acc.address = jsonDecode(widget.initialValue.destination)['account'];
        defaultAcc = acc;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text(dic['bond.reward']),
        SizedBox(
          height: 8,
        ),
        ListTile(
          title: Text(rewardToOptions[
              _rewardTo ?? widget.initialValue.destinationId ?? 0]),
          trailing: Icon(Icons.keyboard_arrow_down, size: 18),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => Container(
                height: MediaQuery.of(context).copyWith().size.height / 3,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 56,
                  scrollController: FixedExtentScrollController(
                      initialItem: widget.initialValue.destinationId ?? 0),
                  children: rewardToOptions
                      .map((i) => Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              i,
                              style: TextStyle(fontSize: 14),
                            ),
                          ))
                      .toList(),
                  onSelectedItemChanged: (v) {
                    setState(() {
                      _rewardTo = v;
                      _rewardAccount = widget.keyring.current;
                    });
                    widget.onChange(v, widget.keyring.current.address);
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 16,
        ),
        (_rewardTo ?? widget.initialValue.destinationId) == 3
            ? AddressInputField(
                widget.plugin.sdk.api,
                widget.keyring.allWithContacts,
                initialValue: _rewardAccount ?? defaultAcc,
                onChanged: (acc) {
                  setState(() {
                    _rewardAccount = acc;
                  });
                  widget.onChange(_rewardTo, acc.address);
                },
                key: ValueKey<KeyPairData>(_rewardAccount),
              )
            : Container(),
        _rewardTo == 3
            ? Row(
                children: [
                  Expanded(
                      child: TextTag(
                    dic['stake.payee.warn'],
                    color: appRed,
                    fontSize: 12,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.all(8),
                  ))
                ],
              )
            : Container(),
      ],
    );
  }
}
