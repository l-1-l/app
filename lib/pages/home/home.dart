import 'package:app/l10n/l10n.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 16.0,
          centerTitle: true,
          title: FractionallySizedBox(
            widthFactor: 0.5,
            child: TabBar(
              // labelPadding: EdgeInsets.symmetric(horizontal: 12),
              labelStyle: Theme.of(context).textTheme.headline6,
              labelColor: Theme.of(context).colorScheme.primary,
              // indicatorSize: TabBarIndicatorSize.label,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0),
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
                    context.router.pushNamed('/auth');
                  },
                  child: Text('Auth'),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Auth'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
