import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView>
    with AutomaticKeepAliveClientMixin<AccountView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final t = context.l10n;

    return Scaffold(
      body: Center(
        child: Text(t.account),
      ),
    );
  }
}
