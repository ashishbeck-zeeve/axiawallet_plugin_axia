import 'package:axiawallet_ui/components/animatedLoadingWheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:axiawallet_plugin_axia/pages/governance/council/motionDetailPage.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/listTail.dart';
import 'package:axiawallet_ui/components/roundedCard.dart';

class Motions extends StatefulWidget {
  Motions(this.plugin);
  final PluginAxia plugin;

  @override
  _MotionsState createState() => _MotionsState();
}

class _MotionsState extends State<Motions> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = true;

  Future<void> _fetchData() async {
    widget.plugin.service.gov.updateBestNumber();
    await widget.plugin.service.gov.queryCouncilMotions();
    if (this.mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _refreshKey.currentState?.show();
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'gov');
    return Observer(
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            RefreshIndicator(
              onRefresh: _fetchData,
              key: _refreshKey,
              child: widget.plugin.store.gov.councilMotions.length == 0
                  ? ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width / 2),
                          child: Center(
                            child: ListTail(isEmpty: true, isLoading: false),
                          ),
                        );
                      })
                  : ListView.builder(
                      itemCount:
                          widget.plugin.store.gov.councilMotions.length + 1,
                      itemBuilder: (_, int i) {
                        if (i ==
                            widget.plugin.store.gov.councilMotions.length) {
                          return Center(
                            child: ListTail(isEmpty: false, isLoading: false),
                          );
                        }
                        final e = widget.plugin.store.gov.councilMotions[i];
                        return RoundedCard(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: ListTile(
                            title: Text(
                                '#${e.votes.index} ${e.proposal.section}.${e.proposal.method}'),
                            subtitle:
                                Text(e.proposal.meta.documentation.trim()),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${e.votes.ayes.length}/${e.votes.threshold}',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(dic['yes']),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  MotionDetailPage.route,
                                  arguments: e);
                            },
                          ),
                        );
                      }),
            ),
            _isLoading
                ? AnimatedLoadingWheel(
                    alt: true,
                  )
                : Container()
          ],
        );
      },
    );
  }
}
