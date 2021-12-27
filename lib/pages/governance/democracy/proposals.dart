import 'package:axiawallet_ui/components/animatedLoadingWheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:axiawallet_plugin_axia/pages/governance/democracy/proposalPanel.dart';
import 'package:axiawallet_plugin_axia/axiawallet_plugin_axia.dart';
import 'package:axiawallet_ui/components/listTail.dart';

class Proposals extends StatefulWidget {
  Proposals(this.plugin);
  final PluginAxia plugin;

  @override
  _ProposalsState createState() => _ProposalsState();
}

class _ProposalsState extends State<Proposals> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = true;

  Future<void> _fetchData() async {
    if (widget.plugin.sdk.api.connectedNode == null) {
      return;
    }
    await widget.plugin.service.gov.queryProposals();
    if (this.mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _refreshKey.currentState.show();
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            RefreshIndicator(
              key: _refreshKey,
              onRefresh: _fetchData,
              child: widget.plugin.store.gov.proposals == null ||
                      widget.plugin.store.gov.proposals.length == 0
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
                      itemCount: widget.plugin.store.gov.proposals.length + 1,
                      itemBuilder: (_, int i) {
                        if (widget.plugin.store.gov.proposals.length == i) {
                          return Center(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width /
                                          2),
                                  child: ListTail(
                                      isEmpty: false, isLoading: false)));
                        }
                        return ProposalPanel(widget.plugin,
                            widget.plugin.store.gov.proposals[i]);
                      }),
            ),
            _isLoading ? AnimatedLoadingWheel(alt: true) : Container()
          ],
        );
      },
    );
  }
}
