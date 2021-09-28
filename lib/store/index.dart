import 'package:axiawallet_plugin_axia/store/accounts.dart';
import 'package:axiawallet_plugin_axia/store/cache/storeCache.dart';
import 'package:axiawallet_plugin_axia/store/gov/governance.dart';
import 'package:axiawallet_plugin_axia/store/staking/staking.dart';

class PluginStore {
  PluginStore(StoreCache cache)
      : staking = StakingStore(cache),
        gov = GovernanceStore(cache);
  final StakingStore staking;
  final GovernanceStore gov;
  final AccountsStore accounts = AccountsStore();
}
