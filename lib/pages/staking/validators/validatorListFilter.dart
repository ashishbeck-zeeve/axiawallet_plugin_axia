import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axiawallet_plugin_axia/utils/i18n/index.dart';
import 'package:axiawallet_sdk/utils/i18n.dart';
import 'package:axiawallet_ui/components/outlinedButtonSmall.dart';

class ValidatorListFilter extends StatelessWidget {
  ValidatorListFilter(
      {this.onSearchChange,
      this.onFilterChange,
      this.filters = const [true, false]});
  final Function(String) onSearchChange;
  final Function(List<bool>) onFilterChange;
  final List<bool> filters;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_axialunar, 'staking');
    var theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              hintText: dic['filter'],
              // hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) => onSearchChange(value.trim()),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              children: <Widget>[
                OutlinedButtonSmall(
                  active: filters[0] == true,
                  content: dic['filter.comm'],
                  onPressed: () {
                    onFilterChange([!filters[0], filters[1]]);
                  },
                ),
                OutlinedButtonSmall(
                  active: filters[1] == true,
                  content: dic['filter.id'],
                  onPressed: () {
                    onFilterChange([filters[0], !filters[1]]);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
