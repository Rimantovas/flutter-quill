import 'package:flutter/material.dart';

import '../../models/documents/attribute.dart';
import '../../models/documents/style.dart';
import '../../models/themes/quill_icon_theme.dart';
import '../controller.dart';
import '../toolbar.dart';

typedef ToggleStyleButtonBuilder = Widget Function(
  BuildContext context,
  Attribute attribute,
  IconData icon,
  LinearGradient? fillColor,
  bool? isToggled,
  VoidCallback? onPressed, [
  double iconSize,
  QuillIconTheme? iconTheme,
]);

class ToggleStyleButton extends StatefulWidget {
  const ToggleStyleButton({
    required this.attribute,
    required this.icon,
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.fillColor,
    this.childBuilder = defaultToggleStyleButtonBuilder,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final Attribute attribute;

  final IconData icon;
  final double iconSize;

  final LinearGradient? fillColor;

  final QuillController controller;

  final ToggleStyleButtonBuilder childBuilder;

  ///Specify an icon theme for the icons in the toolbar
  final QuillIconTheme? iconTheme;

  @override
  _ToggleStyleButtonState createState() => _ToggleStyleButtonState();
}

class _ToggleStyleButtonState extends State<ToggleStyleButton> {
  bool? _isToggled;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  @override
  void initState() {
    super.initState();
    _isToggled = _getIsToggled(_selectionStyle.attributes);
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(
      context,
      widget.attribute,
      widget.icon,
      widget.fillColor,
      _isToggled,
      _toggleAttribute,
      widget.iconSize,
      widget.iconTheme,
    );
  }

  @override
  void didUpdateWidget(covariant ToggleStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggled = _getIsToggled(_selectionStyle.attributes);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  void _didChangeEditingValue() {
    setState(() => _isToggled = _getIsToggled(_selectionStyle.attributes));
  }

  bool _getIsToggled(Map<String, Attribute> attrs) {
    if (widget.attribute.key == Attribute.list.key) {
      final attribute = attrs[widget.attribute.key];
      if (attribute == null) {
        return false;
      }
      return attribute.value == widget.attribute.value;
    }
    return attrs.containsKey(widget.attribute.key);
  }

  void _toggleAttribute() {
    widget.controller.formatSelection(_isToggled!
        ? Attribute.clone(widget.attribute, null)
        : widget.attribute);
  }
}

Widget defaultToggleStyleButtonBuilder(
  BuildContext context,
  Attribute attribute,
  IconData icon,
  LinearGradient? fillColor,
  bool? isToggled,
  VoidCallback? onPressed, [
  double iconSize = kDefaultIconSize,
  QuillIconTheme? iconTheme,
]) {
  final theme = Theme.of(context);
  final isEnabled = onPressed != null;
  // final iconColor = isEnabled
  //     ? isToggled == true
  //         ? (iconTheme?.iconSelectedColor ??
  //             theme
  //                 .primaryIconTheme.color) //You can specify your own icon color
  //         : (iconTheme?.iconUnselectedColor ?? theme.iconTheme.color)
  //     : (iconTheme?.disabledIconColor ?? theme.disabledColor);

  final fill = isEnabled
      ? isToggled == true
          ? fillColor //Selected icon fill color
          : const LinearGradient(colors: [
              Colors.transparent,
              Colors.transparent
            ]) //Unselected icon fill color :
      : (const LinearGradient(colors: [
          Colors.transparent,
          Colors.transparent
        ])); //Disabled icon fill color

  return QuillIconButton(
    highlightElevation: 0,
    hoverElevation: 0,
    size: iconSize * kIconButtonFactor,
    icon: ShaderMask(
      child: Icon(
        icon,
        size: iconSize,
        color: Colors.white,
      ),
      shaderCallback: (bounds) {
        final rect = Rect.fromLTRB(0, 0, iconSize, iconSize);
        return (fill ??
                const LinearGradient(
                    colors: [Colors.transparent, Colors.transparent]))
            .createShader(rect);
      },
    ),
    onPressed: onPressed,
  );
}
