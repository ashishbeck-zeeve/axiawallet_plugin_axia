library axiawallet_plugin_axia;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:axiawallet_plugin_axia/common/constants.dart';
import 'package:axiawallet_plugin_axia/pages/governance.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/candidateDetailPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/candidateListPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/councilPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/councilVotePage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/motionDetailPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/democracy/democracyPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/democracy/proposalDetailPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/democracy/referendumVotePage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/treasury/spendProposalPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/treasury/submitProposalPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/treasury/submitTipPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/treasury/tipDetailPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/treasury/treasuryPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/bondExtraPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/controllerSelectPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/payoutPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/rebondPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/redeemPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/rewardDetailPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/setControllerPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/setPayeePage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/stakePage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/stakingDetailPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/actions/unbondPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/validators/nominatePage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/validators/validatorChartsPage.dart';
import 'package:axiawallet_plugin_axia/pages/staking/validators/validatorDetailPage.dart';
import 'package:axiawallet_plugin_axia/service/index.dart';
import 'package:axiawallet_plugin_axia/store/cache/storeCache.dart';
import 'package:axiawallet_plugin_axia/store/index.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/api/types/networkParams.dart';
import 'package:axiawallet_sdk/plugin/homeNavItem.dart';
import 'package:axiawallet_sdk/plugin/index.dart';
import 'package:axiawallet_sdk/storage/keyring.dart';
import 'package:axiawallet_sdk/storage/types/keyPairData.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/pages/dAppWrapperPage.dart';
import 'package:axiawallet_ui/pages/txConfirmPage.dart';
import 'package:axiawallet_ui/pages/walletExtensionSignPage.dart';

class PluginAxia extends AXIAWalletPlugin {
  /// the axialunar plugin support two networks: axialunar & axia, //axiasolar,
  /// so we need to identify the active network to connect & display UI.
  PluginAxia({name = 'axiasolar'})
      : basic = PluginBasicData(
          name: name,
          genesisHash: name == network_name_axialunar
              ? genesis_hash_axialunar
              : genesis_hash_axiasolar,
          ss58: name == network_name_axialunar ? 2 : 0,
          primaryColor: name == network_name_axialunar
              ? axialunar_black
              : Colors.lightBlue,
          gradientColor:
              name == network_name_axialunar ? Color(0xFF555555) : Colors.blue,
          backgroundImage: AssetImage(
              'packages/axiawallet_plugin_axia/assets/images/public/bg_$name.png'),
          icon: Image.asset(
              'packages/axiawallet_plugin_axia/assets/images/public/$name.png'),
          iconDisabled: Image.asset(
              'packages/axiawallet_plugin_axia/assets/images/public/${name}_gray.png'),
          jsCodeVersion: 21101,
          isTestNet: true,
          isXCMSupport: name == network_name_axialunar,
        ),
        recoveryEnabled = name == network_name_axialunar,
        _cache = name == network_name_axialunar
            ? StoreCacheAXIALunar()
            : StoreCacheAXIASolar();

  @override
  final PluginBasicData basic;

  @override
  final bool recoveryEnabled;

  var customNodes = [];
  @override
  Future<List<NetworkParams>> get nodeList async {
    if (basic.name == network_name_axiasolar) {
      if (customNodes.isEmpty) {
        customNodes = await _checkCustomEndpoints();
        node_list_axiasolar += customNodes;
        print(customNodes);
        return _randomList(node_list_axiasolar)
            .map((e) => NetworkParams.fromJson(e))
            .toList();
      }
      return _randomList(node_list_axiasolar)
          .map((e) => NetworkParams.fromJson(e))
          .toList();
    }
    return _randomList(node_list_axialunar)
        .map((e) => NetworkParams.fromJson(e))
        .toList();
  }

  Future<List> _checkCustomEndpoints() async {
    var url = Uri.parse("https://pastebin.com/raw/FwYWiPJQ");
    var response = await http.get(url);
    // print("customEndPoints are ${response.body}");
    var data = jsonDecode(response.body)["data"];
    print(data.runtimeType);
    return data;
  }

  @override
  final Map<String, Widget> tokenIcons = {
    'KSM': Image.asset(
        'packages/axiawallet_plugin_axia/assets/images/tokens/KSM.png'),
    'DOT': Image.asset(
        'packages/axiawallet_plugin_axia/assets/images/tokens/AXIA.png'),
    'AXIA': Image.asset(
        'packages/axiawallet_plugin_axia/assets/images/tokens/AXIA.png'),
  };

  @override
  List<HomeNavItem> getNavItems(BuildContext context, Keyring keyring) {
    return home_nav_items.map((e) {
      final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'common');
      return HomeNavItem(
        text: dic[e],
        icon: SvgPicture.asset(
          'packages/axiawallet_plugin_axia/assets/images/public/nav_$e.svg',
          color: Theme.of(context).disabledColor,
        ),
        iconActive: SvgPicture.asset(
          'packages/axiawallet_plugin_axia/assets/images/public/nav_$e.svg',
          color: basic.primaryColor,
        ),
        content: e == 'staking' ? Staking(this, keyring) : Gov(this),
      );
    }).toList();
  }

  @override
  Map<String, WidgetBuilder> getRoutes(Keyring keyring) {
    return {
      TxConfirmPage.route: (_) =>
          TxConfirmPage(this, keyring, _service.getPassword),

      // staking pages
      StakePage.route: (_) => StakePage(this, keyring),
      BondExtraPage.route: (_) => BondExtraPage(this, keyring),
      ControllerSelectPage.route: (_) => ControllerSelectPage(this, keyring),
      SetControllerPage.route: (_) => SetControllerPage(this, keyring),
      UnBondPage.route: (_) => UnBondPage(this, keyring),
      RebondPage.route: (_) => RebondPage(this, keyring),
      SetPayeePage.route: (_) => SetPayeePage(this, keyring),
      RedeemPage.route: (_) => RedeemPage(this, keyring),
      PayoutPage.route: (_) => PayoutPage(this, keyring),
      NominatePage.route: (_) => NominatePage(this, keyring),
      StakingDetailPage.route: (_) => StakingDetailPage(this, keyring),
      RewardDetailPage.route: (_) => RewardDetailPage(this, keyring),
      ValidatorDetailPage.route: (_) => ValidatorDetailPage(this, keyring),
      ValidatorChartsPage.route: (_) => ValidatorChartsPage(this, keyring),

      // governance pages
      DemocracyPage.route: (_) => DemocracyPage(this, keyring),
      ReferendumVotePage.route: (_) => ReferendumVotePage(this, keyring),
      CouncilPage.route: (_) => CouncilPage(this, keyring),
      CouncilVotePage.route: (_) => CouncilVotePage(this),
      CandidateListPage.route: (_) => CandidateListPage(this, keyring),
      CandidateDetailPage.route: (_) => CandidateDetailPage(this, keyring),
      MotionDetailPage.route: (_) => MotionDetailPage(this, keyring),
      ProposalDetailPage.route: (_) => ProposalDetailPage(this, keyring),
      TreasuryPage.route: (_) => TreasuryPage(this, keyring),
      SpendProposalPage.route: (_) => SpendProposalPage(this, keyring),
      SubmitProposalPage.route: (_) => SubmitProposalPage(this, keyring),
      SubmitTipPage.route: (_) => SubmitTipPage(this, keyring),
      TipDetailPage.route: (_) => TipDetailPage(this, keyring),
      DAppWrapperPage.route: (_) => DAppWrapperPage(this, keyring),
      WalletExtensionSignPage.route: (_) =>
          WalletExtensionSignPage(this, keyring, _service.getPassword),
    };
  }

  @override
  Future<String> loadJSCode() => null;

  // @override
  // Future<String> loadJSCode() => rootBundle.loadString(
  //     'packages/axiawallet_plugin_axia/lib/js_service_axia/dist/main.js');

  PluginStore _store;
  PluginApi _service;
  PluginStore get store => _store;
  PluginApi get service => _service;

  final StoreCache _cache;

  @override
  Future<void> onWillStart(Keyring keyring) async {
    await GetStorage.init(basic.name == network_name_axiasolar
        ? plugin_axiasolar_storage_key
        : plugin_axialunar_storage_key);

    _store = PluginStore(_cache);

    try {
      loadBalances(keyring.current);

      _store.staking.loadCache(keyring.current.pubKey);
      _store.gov.clearState();
      _store.gov.loadCache();
      print('axialunar plugin cache data loaded');
    } catch (err) {
      print(err);
      print('load axialunar cache data failed');
    }

    _service = PluginApi(this, keyring);
  }

  @override
  Future<void> onStarted(Keyring keyring) async {
    _service.staking.queryElectedInfo();
  }

  @override
  Future<void> onAccountChanged(KeyPairData acc) async {
    _store.staking.loadAccountCache(acc.pubKey);
  }

  List _randomList(List input) {
    final data = input.toList();
    final res = List();
    final _random = Random();
    for (var i = 0; i < input.length; i++) {
      final item = data[_random.nextInt(data.length)];
      res.add(item);
      data.remove(item);
    }
    return res;
  }
}
