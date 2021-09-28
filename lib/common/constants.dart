import 'package:flutter/material.dart';

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year

const node_list_axialunar = [
  {
    'name': 'AXIALunar (AXIASolar Canary, hosted by PatractLabs)',
    'ss58': 2,
    'endpoint': 'wss://axialunar.elara.patract.io',
  },
  {
    'name': 'AXIALunar (AXIASolar Canary, hosted by Parity)',
    'ss58': 2,
    'endpoint': 'wss://axialunar-rpc.axiasolar.io/',
  },
  {
    'name': 'AXIALunar (AXIASolar Canary, hosted by onfinality)',
    'ss58': 2,
    'endpoint': 'wss://axialunar.api.onfinality.io/public-ws',
  },
];
List<dynamic> node_list_axiasolar = [
  {
    'name': 'AXIASolar (Live, hosted by PatractLabs)',
    'ss58': 0,
    'endpoint': 'wss://axiasolar.elara.patract.io',
  },
  {
    'name': 'Altair',
    'ss58': 0,
    'endpoint': 'wss://fullnode.altair.centrifuge.io',
  },
  // {
  //   'name': 'Prod node',
  //   'ss58': 0,
  //   'endpoint': 'wss://fullnode.amber.centrifuge.io',
  // },
  // {
  //   'name': 'Dev node',
  //   'ss58': 0,
  //   'endpoint': 'wss://wss.dev.axiaswap.io',
  // },
  {
    'name': 'Stage node',
    'ss58': 0,
    'endpoint': 'wss://wss.stage.axiacoin.network ',
  },
  // {
  //   'name': 'Mobile node',
  //   'ss58': 0,
  //   'endpoint': 'wss://wss.mobile.axiaswap.io',
  // },
];

const home_nav_items = ['staking', 'governance'];

const MaterialColor axialunar_black = const MaterialColor(
  0xFF222222,
  const <int, Color>{
    50: const Color(0xFF555555),
    100: const Color(0xFF444444),
    200: const Color(0xFF444444),
    300: const Color(0xFF333333),
    400: const Color(0xFF333333),
    500: const Color(0xFF222222),
    600: const Color(0xFF111111),
    700: const Color(0xFF111111),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);

const String genesis_hash_axialunar =
    '0xb0a8d493285c2df73290dfb7e61f870f17b41801197a149ca93654499ea3dafe';
const String genesis_hash_axiasolar =
    '0xf5839524af48f669364221d038bd93f95c615e794cf00d01a862affb973fd92c';
const String network_name_axialunar = 'axialunar';
const String network_name_axiasolar = 'axiasolar';
