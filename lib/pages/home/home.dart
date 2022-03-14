import 'package:app/l10n/l10n.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = context.l10n;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 16,
          centerTitle: true,
          title: FractionallySizedBox(
            widthFactor: 0.5,
            child: TabBar(
              // labelPadding: EdgeInsets.symmetric(horizontal: 12),
              labelStyle: Theme.of(context).textTheme.headline6,
              labelColor: Theme.of(context).colorScheme.primary,
              // indicatorSize: TabBarIndicatorSize.label,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2),
                // insets: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              tabs: [
                Tab(text: t.following),
                Tab(text: t.recommend),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.router.pushNamed('/auth/signin');
                  },
                  child: const Text('Auth'),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Auth'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
