/// The command line, full screen.
///
/// SeekSparks used to have two searches: this app's own `SearchPage`
/// and the Workbench's command pane. They shared the search engine and
/// nothing else — different grammars, different result rows, AI in one
/// and Strong's booleans in the other — so which features a reader got
/// depended on how wide their window was. BibleWorks has exactly one
/// search surface (bwh09) and so does this now: [CommandPane] is the
/// search, and this page is simply the shape it takes when there is no
/// room to put it beside the text.
///
/// That provider is scoped to the Workbench page and is not registered
/// globally, so a route pushed from the Workbench cannot read it. When
/// the Workbench opens this page it passes its own provider as
/// [workbench]: the search scope the reader picked (the book list on the
/// scope sheet, an `l` limit, a Verse List) travels with it, and a scope
/// changed in here is still there when the reader comes back. Before
/// 2026-10-15 the page always built a fresh provider, so choosing John
/// and 1-3 John and then tapping the magnifier searched the whole Bible.
///
/// With no [workbench] (the standalone reader) the page owns a provider
/// of its own and the results live as long as this route does, which is
/// the right lifetime for a search you opened from the reader and will
/// close again the moment you find the verse.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yahwehs_sword/constants/ui_strings.dart';
import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/providers/main_provider.dart';
import 'package:yahwehs_sword/providers/workbench_provider.dart';
import 'package:yahwehs_sword/widgets/command_pane.dart';

class CommandSearchPage extends StatefulWidget {
  const CommandSearchPage({super.key, this.workbench});

  /// The Workbench's own provider, borrowed (never disposed here) so the
  /// search scope it holds applies. Null: the page makes its own.
  final WorkbenchProvider? workbench;

  @override
  State<CommandSearchPage> createState() => _CommandSearchPageState();
}

class _CommandSearchPageState extends State<CommandSearchPage> {
  late final WorkbenchProvider _wb;
  late final bool _ownsWb;
  final FocusNode _commandFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final borrowed = widget.workbench;
    _ownsWb = borrowed == null;
    _wb = borrowed ??
        WorkbenchProvider(mainProvider: context.read<MainProvider>());
    // The reader asked for search; the caret goes in the box. Deferred
    // one frame because the route is still animating in and a focus
    // request during the push is dropped.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _commandFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _commandFocus.dispose();
    if (_ownsWb) _wb.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppSettings>().locale;
    return ChangeNotifierProvider<WorkbenchProvider>.value(
      value: _wb,
      child: Scaffold(
        appBar: AppBar(
          title: Text(uiStrings['search']?[locale] ?? 'Search'),
        ),
        body: SafeArea(
          child: CommandPane(
            focusNode: _commandFocus,
            // Tapping a hit prepares the jump on the shared
            // MainProvider and then gets out of the way — the reader
            // underneath is already scrolled to the verse.
            onVerseOpened: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
    );
  }
}
