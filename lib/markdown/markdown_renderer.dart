import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:flutter_math_fork/flutter_math.dart';


class MarkdownRenderer extends StatelessWidget {
  final String data;
  final MarkdownStyleSheet styleSheet;

  const MarkdownRenderer({
    required this.data, required this.styleSheet,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      styleSheet: styleSheet,
      extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes, [
        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
        KatexInlineSyntax(),
        KatexBlockSyntax()
      ]),
      builders: {
        'katexI': KatexBuilder(false),
        'katexB': KatexBuilder(true),
      },
    );
  }
}

class KatexBuilder extends MarkdownElementBuilder {
  final bool isBlock;

  KatexBuilder(this.isBlock);
  @override
  Widget? visitElementAfter(md.Element element, _) {
    return FittedBox(
      child: Padding(
        padding: isBlock? EdgeInsets.all(10.0): EdgeInsets.all(0.0),
        child: Container(
          alignment: isBlock? Alignment.center:null,
          color:Colors.white10,
          child: Padding(
            padding: isBlock ? EdgeInsets.all(20) : EdgeInsets.all(0),
            child: Math.tex(
              element.textContent,                                                      
              textScaleFactor: 1.2,
              mathStyle: MathStyle.display,
              settings: TexParserSettings(
                displayMode: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class KatexInlineSyntax extends md.InlineSyntax {
  static const String _pattern = r'\$([^$\s][^$\n]*[^$\s])\$';

  KatexInlineSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    var text = match[1]!.trim();
    if (text.isEmpty) return false;

    var el = md.Element.text('katexI', text);
    parser.addNode(el);
    return true;
  }
}

class KatexBlockSyntax extends md.InlineSyntax {
  static const String _pattern = r'\$\$([^$\s][^$\n]*[^$\s])\$\$';

  KatexBlockSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    var text = match[1]!.trim();
    if (text.isEmpty) return false;

    var el = md.Element.text('katexB', text);
    parser.addNode(el);
    return true;
  }
}