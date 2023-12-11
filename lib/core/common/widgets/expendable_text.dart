import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandedbleText extends StatefulWidget {
  const ExpandedbleText(
    this.context, {
    required this.text,
    super.key,
    this.style,
  });

  final BuildContext context;
  final String text;
  final TextStyle? style;

  @override
  State<ExpandedbleText> createState() => _ExpandedbleTextState();
}

class _ExpandedbleTextState extends State<ExpandedbleText> {
  bool expanded = false;
  late TextSpan textSpan;
  late TextPainter textPainter;

  @override
  void initState() {
    textSpan = TextSpan(
      text: widget.text,
    );

    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: expanded ? null : 2,
    )..layout(maxWidth: widget.context.widht * .9);
    super.initState();
  }

  @override
  void dispose() {
    textPainter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
      height: 1.8,
      fontSize: 16,
      color: Colours.neutralTextColour,
    );
    return Container(
      child: textPainter.didExceedMaxLines
          ? RichText(
              text: TextSpan(
                text: expanded
                    ? widget.text
                    : '${widget.text.substring(
                        0,
                        textPainter
                            .getPositionForOffset(
                              Offset(
                                widget.context.widht,
                                widget.context.height,
                              ),
                            )
                            .offset,
                      )}...',
                style: widget.style ?? defaultTextStyle,
                children: [
                  TextSpan(
                    text: expanded ? ' show less' : ' show more',
                    style: const TextStyle(
                      color: Colours.primaryColour,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                  ),
                ],
              ),
            )
          : Text(
              widget.text,
              style: widget.style ?? defaultTextStyle,
            ),
    );
  }
}
