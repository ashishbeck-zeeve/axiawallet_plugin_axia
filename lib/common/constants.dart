import 'package:flutter/material.dart';

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year

const node_list_axialunar = [
  {
    'name': 'AXIALunar (AXIA Canary, hosted by PatractLabs)',
    'ss58': 2,
    'endpoint': 'wss://axialunar.elara.patract.io',
  },
  {
    'name': 'AXIALunar (AXIA Canary, hosted by Parity)',
    'ss58': 2,
    'endpoint': 'wss://axialunar-rpc.axia.io/',
  },
  {
    'name': 'AXIALunar (AXIA Canary, hosted by onfinality)',
    'ss58': 2,
    'endpoint': 'wss://axialunar.api.onfinality.io/public-ws',
  },
];
List<dynamic> node_list_axia = [
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

Map<int, Color> getSwatch(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;

  /// if [500] is the default color, there are at LEAST five
  /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
  /// divisor of 5 would mean [50] is a lightness of 1.0 or
  /// a color of #ffffff. A value of six would be near white
  /// but not quite.
  final lowDivisor = 6;

  /// if [500] is the default color, there are at LEAST four
  /// steps above [500]. A divisor of 4 would mean [900] is
  /// a lightness of 0.0 or color of #000000
  final highDivisor = 5;

  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;

  return {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  };
}

MaterialColor axia_blue =
    MaterialColor(Color(0xff178fe1).value, getSwatch(Color(0xff178fe1)));

Color appRed = Color(0xffF12F2F);
Color appGreen = Color(0xff35B994);

const String genesis_hash_axialunar =
    '0xb0a8d493285c2df73290dfb7e61f870f17b41801197a149ca93654499ea3dafe';
const String genesis_hash_axia =
    '0xf5839524af48f669364221d038bd93f95c615e794cf00d01a862affb973fd92c';
const String network_name_axialunar = 'axialunar';
const String network_name_axia = 'axia';
