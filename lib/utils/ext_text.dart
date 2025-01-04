import 'package:chatting_app/utils/base_color.dart';
import 'package:flutter/material.dart';

extension TextExtension on Text {
  Text spd42m() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 42,
          fontWeight: FontWeight.w500,
        ),
      );
  Text spd34m() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 34,
          fontWeight: FontWeight.w500,
        ),
      );
  Text spd28m() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      );
  Text spd20sm() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      );
  Text spd12r() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );

  Text spd14r() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
  Text spd14m() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );

  Text spd14sm() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      );

  Text spd16r() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      );
  Text spd16m() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
  Text spd16sm() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );

  Text spd18sm() => copyWith(
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );

  Text white() => copyWith(style: const TextStyle(color: BaseColor.white));
  Text black() => copyWith(style: const TextStyle(color: BaseColor.black));
  Text textColor() => copyWith(style: const TextStyle(color: BaseColor.text));
  Text grey() => copyWith(style: const TextStyle(color: BaseColor.subtitle));
  Text grey2() => copyWith(style: const TextStyle(color: BaseColor.border));
  Text primary() => copyWith(style: const TextStyle(color: BaseColor.primary));
  Text red() => copyWith(style: const TextStyle(color: BaseColor.danger));

  Text copyWith({
    Key? key,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection = TextDirection.ltr,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextStyle? style,
  }) {
    return Text(data ?? '',
        key: key ?? this.key,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        locale: locale ?? this.locale,
        softWrap: softWrap ?? this.softWrap,
        overflow: overflow ?? this.overflow,
        maxLines: maxLines ?? this.maxLines,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
        style: style != null ? this.style?.merge(style) ?? style : this.style);
  }
}
