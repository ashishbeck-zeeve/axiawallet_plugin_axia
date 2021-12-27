import 'package:axiawallet_ui/components/iosBackButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/addressFormItem.dart';
import 'package:axiawallet_ui/components/txButton.dart';
import 'package:axiawallet_ui/utils/format.dart';
import 'package:axiawallet_ui/utils/index.dart';

class UnBondPage extends StatefulWidget {
  UnBondPage(this.plugin, this.keyring);
  static final String route = '/staking/unbond';
  final PluginAxia plugin;
  final Keyring keyring;
  @override
  _UnBondPageState createState() => _UnBondPageState();
}

class _UnBondPageState extends State<UnBondPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();

  BigInt _minNominate = BigInt.zero;

  Future<void> _queryMinNominate() async {
    final min = await widget.plugin.sdk.webView
        .evalJavascript('api.query.staking.minNominatorBond()');
    setState(() {
      _minNominate = Fmt.balanceInt(min);
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queryMinNominate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'common');
    final dicStaking =
        I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');
    final symbol = (widget.plugin.networkState.tokenSymbol ?? ['AXC'])[0];
    final decimals = (widget.plugin.networkState.tokenDecimals ?? [12])[0];

    final stashInfo = widget.plugin.store.staking.ownStashInfo;
    double bonded = 0;
    bool hasNomination = false;
    if (stashInfo != null) {
      bonded = Fmt.bigIntToDouble(
          BigInt.parse(stashInfo.stakingLedger['active'].toString()), decimals);
      hasNomination = stashInfo.nominating.length > 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dicStaking['action.unbond']),
        centerTitle: true,
        leading: IOSBackButton(),
      ),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      AddressFormItem(
                        widget.keyring.current,
                        label: dicStaking['controller'],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                          '${dic['amount']} (${dicStaking['bonded']}: ${Fmt.priceFloor(
                        bonded,
                        lengthMax: 4,
                      )} $symbol)'),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          hintText: dic['amount'],
                          errorMaxLines: 3,
                        ),
                        inputFormatters: [UI.decimalInputFormatter(decimals)],
                        controller: _amountCtrl,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v.isEmpty) {
                            return dic['amount.error'];
                          }
                          final amount = double.parse(v.trim());
                          if (amount > bonded) {
                            return dic['amount.low'];
                          }
                          if (hasNomination &&
                              bonded - amount <=
                                  Fmt.bigIntToDouble(_minNominate, decimals)) {
                            return dicStaking['bond.unbond.min'];
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TxButton(
                  getTxParams: () async {
                    if (_formKey.currentState.validate()) {
                      final inputAmount = _amountCtrl.text.trim();
                      return TxConfirmParams(
                        txTitle: dicStaking['action.unbond'],
                        module: 'staking',
                        call: 'unbond',
                        txDisplay: {"amount": '$inputAmount $symbol'},
                        params: [
                          // "amount"
                          Fmt.tokenInt(inputAmount, decimals).toString(),
                        ],
                      );
                    }
                    return null;
                  },
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
