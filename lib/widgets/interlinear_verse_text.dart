/// 2026-09-08 (SeekSparks): one verse of a tagged translation, set as a
/// running line with its Strong's numbers in it.
///
/// This is the form 精读圣经 prints and the one the owner asked the
/// Exegesis panel for:
///
///     地<0776>是<01961>空虚<08414>混沌<0922>，渊<08415>面<06440>黑暗<02822>；
///
/// The panel's word grid answers "what are the original words". This
/// answers a different question — "where in the sentence I read is each
/// of them" — and it can only be answered against a particular edition,
/// because the numbers hang off that edition's own printed words.
///
/// ## What a run is, and the limitation this widget inherits whole
///
/// `assets/tagged/` tags by **run, not by word**, and a run can be
/// several words: the BSB's Genesis 1:2 opens `{"w": "Now the earth ",
/// "s": "H776"}`. H776 is אֶרֶץ, "earth" — *Now* and *the* are the BSB's
/// English and render nothing. `strongs_tag_binding.dart` records the
/// same limitation for the search path and it is not fixable here:
/// splitting a run onto a head word would be this widget guessing at an
/// alignment the importer did not record. So one number sits after one
/// run however many words that run holds, and the tap target is the
/// whole run for the same reason — there is nothing finer in the data
/// to point at.
///
/// Each displayed lexical number has its own navigation target. The
/// whole translated run remains clickable as a larger fallback target.
/// Recognizers are owned and disposed by this widget's state.
///
/// ## Colour
///
/// Green for a lexical number, blue for a grammar code, and an implied
/// number in the lexical hue at 60% — [WbColors.strongsLexical] and
/// [WbColors.strongsGrammar] verbatim, via [inlineStrongsNumbers], with
/// no re-tinting. Those two are DATA colours: they are the reason a
/// tagged line stays readable with the numbers on, because the eye
/// filters by hue instead of parsing. A panel that re-mixed them to
/// suit its own surface would break that across the app.
library;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:yahwehs_sword/constants/word_study_style.dart';
import 'package:yahwehs_sword/constants/workbench_theme.dart';
import 'package:yahwehs_sword/services/tagged_text_service.dart';
import 'package:yahwehs_sword/utils/font_catalog.dart' show kCjkFontFallback;
import 'package:yahwehs_sword/utils/scripture_markup.dart';
import 'package:yahwehs_sword/utils/strongs_inline.dart';

class InterlinearVerseText extends StatefulWidget {
  const InterlinearVerseText({
    super.key,
    required this.runs,
    required this.style,
    required this.showNumbers,
    this.highlightStrongs,
    this.onTapRun,
    this.onTapNumber,
  });

  /// The verse, as `TaggedTextService.forVerse` returned it.
  final List<TaggedRun> runs;

  /// The panel's resolved presentation — the modal sheet's proportions
  /// or the docked pane's. Passed in rather than resolved here so this
  /// widget cannot disagree with the panel hosting it about what size a
  /// gloss is.
  final WordStudyStyle style;

  /// The reader's `showStrongsInOriginals` preference, which is a
  /// statement about this panel specifically. False leaves the
  /// translation set as running prose — the same words in the same
  /// order, minus the apparatus.
  final bool showNumbers;

  /// The number of the word whose entry card is open, so the runs that
  /// render it are marked in the sentence. This is the join between the
  /// two halves of the panel: tap a card, see where in the verse it is.
  final String? highlightStrongs;

  /// Called with the whole run, not just its number, because the caller
  /// needs the printed text to fall back on when the originals asset
  /// has no word carrying that number.
  final void Function(TaggedRun run)? onTapRun;

  final void Function(TaggedRun run, String number)? onTapNumber;

  @override
  State<InterlinearVerseText> createState() => _InterlinearVerseTextState();
}

class _InterlinearVerseTextState extends State<InterlinearVerseText> {
  final Map<(TaggedRun, String), TapGestureRecognizer> _recognizers = {};
  List<TaggedRun> get runs => widget.runs;
  WordStudyStyle get style => widget.style;
  bool get showNumbers => widget.showNumbers;
  String? get highlightStrongs => widget.highlightStrongs;
  void Function(TaggedRun)? get onTapRun => widget.onTapRun;

  TapGestureRecognizer _numberTap(TaggedRun run, String number) =>
      _recognizers.putIfAbsent(
          (run, number),
          () => TapGestureRecognizer()
            ..onTap = () => widget.onTapNumber?.call(run, number));

  void _clearRecognizers() {
    for (final r in _recognizers.values) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  void didUpdateWidget(covariant InterlinearVerseText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.runs, widget.runs)) _clearRecognizers();
  }

  @override
  void dispose() {
    _clearRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wb = WbColors.of(context);
    return Wrap(
      // No `spacing`: a tagged English run carries its own trailing
      // space and a Chinese one deliberately has none. Adding a gap
      // here would double the first and invent the second.
      runSpacing: 0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [for (final run in runs) _run(context, wb, run)],
    );
  }

  Widget _run(BuildContext context, WbColors wb, TaggedRun run) {
    final (stem, trailing) = splitTrailingCjkPunctuation(run.text);
    final numbers = showNumbers
        ? inlineStrongsNumbers(
            strongs: run.strongs,
            grammar: run.grammar,
            implied: run.implied,
            additional: run.additional,
          )
        : const <StrongsNumberToken>[];

    final body = Text.rich(
      TextSpan(children: [
        for (final span in parseScripture(stem))
          if (span.kind == ScriptureSpanKind.divineName ||
              span.kind == ScriptureSpanKind.gloss)
            glossSpan(span, wb)
          else if (span.kind == ScriptureSpanKind.versification)
            versificationSpan(span, wb, fontSize: style.gloss)
          else
            TextSpan(
              text: span.text,
              style: span.kind == ScriptureSpanKind.supplied
                  ? const TextStyle(fontStyle: FontStyle.italic)
                  : null,
            ),
        for (final n in numbers)
          TextSpan(
            text: ' ${n.text}',
            recognizer: n.lexicalNumber != null && widget.onTapNumber != null
                ? _numberTap(run, n.lexicalNumber!)
                : null,
            style: TextStyle(
              fontSize: style.gloss,
              fontWeight: FontWeight.w500,
              color: switch (n.kind) {
                StrongsNumberKind.lexical => wb.strongsLexical,
                StrongsNumberKind.grammar => wb.strongsGrammar,
                StrongsNumberKind.implied =>
                  wb.strongsLexical.withValues(alpha: 0.6),
              },
            ),
          ),
        // Chinese sets no space between words, so without this the next
        // run's first character butts against the number: 地H776是.
        // English runs already end in one and get nothing extra.
        if (numbers.isNotEmpty) const TextSpan(text: ' '),
        if (trailing.isNotEmpty) TextSpan(text: trailing),
      ]),
      style: TextStyle(
        fontSize: style.body,
        height: style.dense ? WbMetrics.lineHeight : 1.6,
        color: Theme.of(context).colorScheme.onSurface,
        fontFamilyFallback: kCjkFontFallback,
      ),
    );

    final marked = [run.strongs, ...run.additional, ...run.implied]
        .contains(highlightStrongs);
    if ((!run.isTagged && run.implied.isEmpty && run.additional.isEmpty) ||
        onTapRun == null) {
      return _box(marked: marked, child: body);
    }
    return InkWell(
      onTap: () => onTapRun!(run),
      borderRadius: style.r(4),
      child: _box(marked: marked, child: body),
    );
  }

  /// The run's box. Horizontal padding only, and one pixel of it: the
  /// line has to read as a sentence, so a run may not look like a chip.
  Widget _box({required bool marked, required Widget child}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        decoration: marked
            ? BoxDecoration(
                color: style.selectedFill,
                borderRadius: style.r(4),
              )
            : null,
        child: child,
      );
}
