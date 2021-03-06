import 'package:axiawallet_ui/components/animatedLoadingWheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/councilPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/democracy/democracyPage.dart';
import 'package:axiawallet_plugin_axia/pages/governance/treasury/treasuryPage.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/plugin/index.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/entryPageCard.dart';
import 'package:axiawallet_ui/components/cupertinoTabBar.dart';
import 'package:axiawallet_ui/pages/dAppWrapperPage.dart';

class Gov extends StatelessWidget {
  Gov(this.plugin);

  final AXIAWalletPlugin plugin;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'gov');
    final dicCommon =
        I18n.of(context).getDic(i18n_full_dic_axialunar, 'common');

    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          I18n.of(context)
              .getDic(i18n_full_dic_axialunar, 'common')['governance'],
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).cardColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Text(
            //         I18n.of(context).getDic(
            //             i18n_full_dic_axialunar, 'common')['governance'],
            //         style: TextStyle(
            //           fontSize: 20,
            //           color: Theme.of(context).cardColor,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Expanded(
              child: plugin.sdk.api.connectedNode == null
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width / 2),
                        child: Column(
                          children: [
                            AnimatedLoadingWheel(alt: true),
                            Text(dicCommon['node.connecting']),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.all(16),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            child: EntryPageCard(
                              dic['democracy'],
                              dic['democracy.brief'],
                              SvgPicture.asset(
                                'packages/axiawallet_plugin_axia/assets/images/gov/democracy.svg',
                                width: 48,
                                // color: Theme.of(context).primaryColor,
                              ),
                              color: Colors.transparent,
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed(DemocracyPage.route),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            child: EntryPageCard(
                              dic['council'],
                              dic['council.brief'],
                              SvgPicture.asset(
                                'packages/axiawallet_plugin_axia/assets/images/gov/council.svg',
                                width: 48,
                                // color: Theme.of(context).primaryColor,
                              ),
                              color: Colors.transparent,
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed(CouncilPage.route),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            child: EntryPageCard(
                              dic['treasury'],
                              dic['treasury.brief'],
                              SvgPicture.asset(
                                'packages/axiawallet_plugin_axia/assets/images/gov/treasury.svg',
                                width: 48,
                                // color: Theme.of(context).primaryColor,
                              ),
                              color: Colors.transparent,
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed(TreasuryPage.route),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 16),
                        //   child: GestureDetector(
                        //     child: EntryPageCard(
                        //       'axiassembly',
                        //       dic['axiassembly'],
                        //       Image.asset(
                        //         'packages/axiawallet_plugin_axia/assets/images/public/axiassembly.png',
                        //         width: 48,
                        //       ),
                        //       color: Colors.transparent,
                        //     ),
                        //     onTap: () => Navigator.of(context).pushNamed(
                        //       DAppWrapperPage.route,
                        //       arguments:
                        //           'https://${plugin.basic.name}.axiassembly.io/',
                        //       // "https://axia.js.org/apps/",
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
