/// VelocityX 호환성 레이어
/// VelocityX를 Flutter 기본 위젯으로 대체하기 위한 유틸리티

import 'package:flutter/material.dart';

// Extension for int spacing
extension IntExtensions on int {
  Widget get heightBox => SizedBox(height: toDouble());
  Widget get widthBox => SizedBox(width: toDouble());
}

// Extension for String text builder
extension StringExtensions on String {
  VxTextBuilder get text => VxTextBuilder(this);
}

// Simple text builder class
class VxTextBuilder {
  final String _text;
  TextStyle _style = const TextStyle();
  TextAlign? _textAlign;
  int? _maxLines;
  TextOverflow? _overflow;

  VxTextBuilder(this._text);

  VxTextBuilder size(double size) {
    _style = _style.copyWith(fontSize: size);
    return this;
  }

  VxTextBuilder color(Color? color) {
    _style = _style.copyWith(color: color);
    return this;
  }

  VxTextBuilder fontWeight(FontWeight weight) {
    _style = _style.copyWith(fontWeight: weight);
    return this;
  }

  VxTextBuilder get bold {
    _style = _style.copyWith(fontWeight: FontWeight.bold);
    return this;
  }

  VxTextBuilder get white {
    _style = _style.copyWith(color: Colors.white);
    return this;
  }

  VxTextBuilder get gray500 {
    _style = _style.copyWith(color: Colors.grey[500]);
    return this;
  }

  VxTextBuilder get gray600 {
    _style = _style.copyWith(color: Colors.grey[600]);
    return this;
  }

  VxTextBuilder get gray700 {
    _style = _style.copyWith(color: Colors.grey[700]);
    return this;
  }

  VxTextBuilder get gray800 {
    _style = _style.copyWith(color: Colors.grey[800]);
    return this;
  }

  VxTextBuilder lineHeight(double height) {
    _style = _style.copyWith(height: height);
    return this;
  }

  VxTextBuilder get center {
    _textAlign = TextAlign.center;
    return this;
  }

  VxTextBuilder textAlign(TextAlign align) {
    _textAlign = align;
    return this;
  }

  VxTextBuilder maxLines(int lines) {
    _maxLines = lines;
    return this;
  }

  VxTextBuilder get ellipsis {
    _overflow = TextOverflow.ellipsis;
    return this;
  }

  Widget make() {
    return Text(
      _text,
      style: _style,
      textAlign: _textAlign,
      maxLines: _maxLines,
      overflow: _overflow ?? (_maxLines != null ? TextOverflow.ellipsis : null),
    );
  }

  Widget makeCentered() {
    return Center(
      child: make(),
    );
  }
}

// Extension for widget styling
extension WidgetExtensions on Widget {
  Widget p(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );

  Widget p16() => Padding(
        padding: const EdgeInsets.all(16),
        child: this,
      );

  Widget px(double padding) => Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: this,
      );

  Widget pOnly({double left = 0, double top = 0, double right = 0, double bottom = 0}) => Padding(
        padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );

  Widget pSymmetric({double h = 0, double v = 0}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
        child: this,
      );

  Widget centered() => Center(child: this);

  Widget get card => Card(
        child: this,
      );

  Widget get rounded => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: this,
      );

  Widget elevation(double elevation) => Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(12),
        child: this,
      );

  Widget onTap(VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: this,
      );

  Widget make() => this;

  // Flutter animate 호환
  Widget shimmer({
    Color primaryColor = Colors.white,
    Color secondaryColor = Colors.white70,
  }) => this; // 실제 shimmer는 flutter_animate로 처리
}

// Column/Row extensions
extension FlexExtensions on Column {
  Widget centered() => Center(child: this);
}

extension ListExtensions<T> on List<T> {
  List<T> take(int count) => sublist(0, count > length ? length : count);
}