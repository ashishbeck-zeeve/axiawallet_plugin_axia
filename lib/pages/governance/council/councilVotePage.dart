import 'dart:convert';
import 'dart:math';

import 'package:axiawallet_ui/components/iosBackButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/candidateListPage.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/addressIcon.dart';
import 'package:axiawallet_ui/components/txButton.dart';
import 'package:axiawallet_ui/utils/format.dart';
import 'package:axiawallet_ui/utils/i18n.dart';
import 'package:axiawallet_ui/utils/index.dart';

class CouncilVotePage extends StatefulWidget {
  CouncilVotePage(this.plugin);
  final PluginAxia plugin;

  static final String route = '/gov/vote';
  @override
  _CouncilVote createState() => _CouncilVote();
}

class _CouncilVote extends State<CouncilVotePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();

  List<List> _selected = List<List>();

  Future<void> _handleCandidateSelect() async {
    var res = await Navigator.of(context)
        .pushNamed(CandidateListPage.route, arguments: _selected);
    if (res != null) {
      setState(() {
        _selected = List<List>.of(res);
      });
    }
  }

  Future<TxConfirmParams> _getTxParams() async {
    if (_formKey.currentState.validate()) {
      final govDic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'gov');
      final decimals = (widget.plugin.networkState.tokenDecimals ?? [12])[0];
      final amt = _amountCtrl.text.trim();
      List selected = _selected.map((i) => i[0]).toList();
      final moduleName = await widget.plugin.service.getRuntimeModuleName(
          ['electionsPhragmen', 'elections', 'phragmenElection']);
      return TxConfirmParams(
        module: moduleName,
        call: 'vote',
        txTitle: govDic['vote.candidate'],
        txDisplay: {
          "votes": selected,
          "voteValue": amt,
        },
        params: [
          // "votes"
          selected,
          // "voteValue"
          Fmt.tokenInt(amt, decimals).toString(),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var govDic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'gov');
    return Scaffold(
      appBar: AppBar(
        title: Text(govDic['vote.candidate']),
        centerTitle: true,
        leading: IOSBackButton(),
      ),
      body: Observer(
        builder: (_) {
          final dic =
              I18n.of(context).getDic(i18n_full_dic_axialunar, 'common');
          final decimals =
              (widget.plugin.networkState.tokenDecimals ?? [12])[0];

          final balance = Fmt.balanceInt(
              widget.plugin.balances.native.freeBalance.toString());

          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: ListView(
                        children: <Widget>[
                          Text(
                              '${dic['amount']} (${dic['balance']}: ${Fmt.token(balance, decimals)})'),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: dic['amount'],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            inputFormatters: [
                              UI.decimalInputFormatter(decimals)
                            ],
                            controller: _amountCtrl,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (v) {
                              if (v.isEmpty) {
                                return dic['amount.error'];
                              }
                              if (double.parse(v.trim()) >=
                                  balance / BigInt.from(pow(10, decimals)) -
                                      0.001) {
                                return dic['amount.low'];
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          OutlinedButton(
                              onPressed: () {
                                _handleCandidateSelect();
                              },
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(16),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(govDic['candidate']),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.arrow_right_alt,
                                    ),
                                  )
                                ],
                              )),
                          // ListTile(
                          //   title: Text(govDic['candidate']),
                          //   trailing: Icon(Icons.arrow_forward_ios, size: 18),
                          //   onTap: () {
                          //     _handleCandidateSelect();
                          //   },
                          // ),
                          Column(
                            children: _selected.map((i) {
                              final accInfo = widget
                                  .plugin.store.accounts.addressIndexMap[i[0]];
                              return Container(
                                margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 32,
                                      margin: EdgeInsets.only(right: 8),
                                      child: AddressIcon(
                                        i[0],
                                        svg: widget.plugin.store.accounts
                                            .addressIconsMap[i[0]],
                                        size: 32,
                                        tapToCopy: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          UI.accountDisplayName(i[0], accInfo),
                                          Text(
                                            Fmt.address(i[0]),
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: TxButton(
                    getTxParams: _getTxParams,
                    text: I18n.of(context)
                        .getDic(i18n_full_dic_ui, 'common')['tx.submit'],
                    onFinish: (res) {
                      if (res != null) {
                        Navigator.of(context).pop(res);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
