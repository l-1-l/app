import 'dart:ui';

import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/drag_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'translator.dart';
import 'search_box.dart';
import 'country_type.dart';
import 'country.dart';

class CountrySelector extends StatefulWidget {
  final ScrollController? controller;
  final void Function(ICountry country)? onSelected;

  const CountrySelector({
    Key? key,
    this.controller,
    this.onSelected,
  }) : super(key: key);

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  late final IList<ICountry> countries;
  late final TextEditingController searchController;
  // late final Debouncer<String?> searchDebouncer;

  IList<ICountry>? searchResults;

  @override
  void initState() {
    super.initState();
    // searchDebouncer = Debouncer<String?>(
    //   const Duration(milliseconds: 200),
    //   initialValue: null,
    // );
    searchController = TextEditingController();
    // searchController
    // .addListener(() => searchDebouncer.value = searchController.text);
    // searchDebouncer.values.listen(search);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    countries = initData();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    EasyDebounce.cancel('searchDebouncer');
  }

  IList<ICountry> initData() => allCountries.map((json) {
        json['name'] = CountryTranslator.getNameForCode(context, json['code']);
        return ICountry.fromJson(json);
      }).toIList();

  handleSearchChange(String val) {
    EasyDebounce.debounce(
      'searchDebouncer',
      const Duration(microseconds: 200),
      () {
        search(val);
      },
    );
  }

  void search(String? val) {
    if (val == null || val == '') {
      if (searchResults == null) return;
      setState(() {
        searchResults = null;
      });
      return;
    }

    final result = countries.where((c) {
      return (c.name.toLowerCase().contains(val) ||
          c.countryName.toLowerCase().contains(val) ||
          c.nativeName.toLowerCase().contains(val) ||
          c.dialCode.contains(val));
    }).toIList();

    setState(() {
      searchResults = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = context.l10n;
    final data = searchResults ?? countries;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: cs.outline,
                  width: .5,
                ),
              ),
            ),
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const DragHandle(),
                Expanded(
                  child: Align(
                    child: AutoSizeText(
                      t.region,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
          // title:
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: cs.outline,
                    ),
                  ),
                ),
                child: SearchBox(
                  controller: searchController,
                  onChange: handleSearchChange,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    controller: widget.controller,
                    // physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Country(
                        key: ValueKey(data[index].code),
                        country: data[index],
                        onTap: widget.onSelected,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
