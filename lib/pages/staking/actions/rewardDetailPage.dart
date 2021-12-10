import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/store/staking/types/txData.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/txDetail.dart';
import 'package:axiawallet_ui/utils/format.dart';

class RewardDetailPage extends StatelessWidget {
  RewardDetailPage(this.plugin, this.keyring);

  static final String route = '/staking/rewards';
  final PluginAxia plugin;
  final Keyring keyring;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'common');
    final dicStaking =
        I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');
    final decimals = (plugin.networkState.tokenDecimals ?? [12])[0];
    final symbol = (plugin.networkState.tokenSymbol ?? ["AXC"])[0];
    final TxRewardData detail = ModalRoute.of(context).settings.arguments;

    return TxDetail(
      networkName: plugin.basic.name,
      success: true,
      action: detail.eventId,
      fee: '0',
      hash: detail.extrinsicHash,
      eventId: detail.eventIndex,
      infoItems: <TxDetailInfoItem>[
        TxDetailInfoItem(
            label: dicStaking['txs.event'], content: Text(detail.eventId)),
        TxDetailInfoItem(
          label: dic['amount'],
          content: Text('${Fmt.balance(detail.amount, decimals)} $symbol'),
        ),
      ],
      blockTime: Fmt.dateTime(
          DateTime.fromMillisecondsSinceEpoch(detail.blockTimestamp * 1000)),
      blockNum: detail.blockNum,
    );
  }
}
