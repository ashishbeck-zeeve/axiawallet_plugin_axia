import 'package:get_storage/get_storage.dart';

const String plugin_axialunar_storage_key = 'plugin_axialunar';
const String plugin_axia_storage_key = 'plugin_axia';

abstract class StoreCache {
  static final _storage = () => GetStorage(plugin_axialunar_storage_key);

  /// staking network state
  final stakingOverview = {}.val('stakingOverview', getBox: _storage);
  final validatorsInfo = {}.val('validatorsInfo', getBox: _storage);

  /// governance network state
  final councilInfo = {}.val('councilInfo', getBox: _storage);

  /// account staking data
  final stakingOwnStash = {}.val('stakingOwnStash', getBox: _storage);
  final stakingTxs = {}.val('stakingTxs', getBox: _storage);
  final stakingRewardTxs = {}.val('stakingRewardTxs', getBox: _storage);
}

class StoreCacheAXIALunar extends StoreCache {
  static final _storage = () => GetStorage(plugin_axialunar_storage_key);

  /// staking network state
  final stakingOverview = {}.val('stakingOverview', getBox: _storage);
  final validatorsInfo = {}.val('validatorsInfo', getBox: _storage);

  /// governance network state
  final councilInfo = {}.val('councilInfo', getBox: _storage);

  /// account staking data
  final stakingOwnStash = {}.val('stakingOwnStash', getBox: _storage);
  final stakingTxs = {}.val('stakingTxs', getBox: _storage);
  final stakingRewardTxs = {}.val('stakingRewardTxs', getBox: _storage);
}

class StoreCacheAXIA extends StoreCache {
  static final _storage = () => GetStorage(plugin_axia_storage_key);

  /// staking network state
  final stakingOverview = {}.val('stakingOverview', getBox: _storage);
  final validatorsInfo = {}.val('validatorsInfo', getBox: _storage);

  /// governance network state
  final councilInfo = {}.val('councilInfo', getBox: _storage);

  /// account staking data
  final stakingOwnStash = {}.val('stakingOwnStash', getBox: _storage);
  final stakingTxs = {}.val('stakingTxs', getBox: _storage);
  final stakingRewardTxs = {}.val('stakingRewardTxs', getBox: _storage);
}
