import 'package:flutter/material.dart';

/// Widget extensions to replace velocity_x functionality
extension WidgetExtensions on Widget {
  Widget px(double padding) => Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: this,
  );
  
  Widget py(double padding) => Padding(
    padding: EdgeInsets.symmetric(vertical: padding),
    child: this,
  );
  
  Widget p(double padding) => Padding(
    padding: EdgeInsets.all(padding),
    child: this,
  );
  
  Widget pOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left ?? 0,
      top: top ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0,
    ),
    child: this,
  );
  
  Widget get centered => Center(child: this);
  Widget get center => Center(child: this);
}

/// String extensions for text widgets
extension StringExtensions on String {
  Text get text => Text(this);
}

/// Text extensions for styling
extension TextExtensions on Text {
  Text textStyle(TextStyle style) => Text(
    data!,
    key: key,
    style: style,
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
  
  Text color(Color color) => Text(
    data!,
    key: key,
    style: (style ?? const TextStyle()).copyWith(color: color),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
  
  Text size(double size) => Text(
    data!,
    key: key,
    style: (style ?? const TextStyle()).copyWith(fontSize: size),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
  
  Text get bold => Text(
    data!,
    key: key,
    style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
  
  Text align(TextAlign align) => Text(
    data!,
    key: key,
    style: style,
    strutStyle: strutStyle,
    textAlign: align,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
  
  Text fontWeight(FontWeight weight) => Text(
    data!,
    key: key,
    style: (style ?? const TextStyle()).copyWith(fontWeight: weight),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
  
  Widget make() => this;
  
  Widget makeCentered() => Center(child: this);
}

// Color extensions for convenience
extension ColorStringExtensions on Text {
  Text get gray700 => color(Colors.grey[700]!);
  Text get gray600 => color(Colors.grey[600]!);
  Text get gray500 => color(Colors.grey[500]!);
}