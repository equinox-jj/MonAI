import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/icons/monai_icon.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';

/// 32 filter chip with 8 corners (Transactions filters).
///
/// Selected chips get a check; [hasDropdown] adds a chevron for chips that
/// open a picker.
class MonAIFilterChip extends StatelessWidget {
  /// Creates a filter chip.
  const MonAIFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
    this.hasDropdown = false,
  });

  /// The text.
  final String label;

  /// Whether the filter is on.
  final bool selected;

  /// Toggles the filter or opens its picker.
  final VoidCallback onTap;

  /// Shows a chevron.
  final bool hasDropdown;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final content = selected ? c.onPrimaryContainer : c.iconStrong;
    return Semantics(
      checked: selected,
      button: true,
      child: SizedBox(
        height: MonAISizes.filterChip,
        child: Material(
          color: selected ? c.primaryContainer : c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: MonAIRadius.smAll,
            side: BorderSide(
              color: selected ? c.primaryContainerBorder : c.borderStrong,
            ),
          ),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const .symmetric(horizontal: MonAISpacing.x2_5),
              child: Row(
                mainAxisSize: .min,
                spacing: MonAISpacing.x1,
                children: [
                  if (selected)
                    MonAIIcon(
                      MonAIIcons.check,
                      size: MonAISizes.iconSm,
                      color: content,
                    ),
                  Text(
                    label,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: content,
                    ),
                  ),
                  if (hasDropdown)
                    MonAIIcon(
                      MonAIIcons.expandMore,
                      size: MonAISizes.iconSm,
                      color: content,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One option of a [MonAISegmentedControl], with optional selected colors.
@immutable
class MonAISegment<T> {
  /// Creates a segment.
  const MonAISegment({
    required this.value,
    required this.label,
    this.selectedContainer,
    this.selectedContent,
  });

  /// The value [MonAISegmentedControl.onChanged] reports.
  final T value;

  /// The text.
  final String label;

  /// Fill when selected; defaults to `surface`.
  final Color? selectedContainer;

  /// Text color when selected; defaults to `textPrimary`.
  final Color? selectedContent;
}

/// Pill segmented control (Expense / Income / Transfer).
class MonAISegmentedControl<T> extends StatelessWidget {
  /// Creates a segmented control.
  const MonAISegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// The options, left to right.
  final List<MonAISegment<T>> segments;

  /// The selected option's value.
  final T selected;

  /// Called with the tapped option's value.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MonAISizes.segmentedControl,
      padding: const .all(MonAISpacing.x1),
      decoration: BoxDecoration(
        color: context.colors.surfaceSunken,
        borderRadius: MonAIRadius.fullAll,
      ),
      child: Row(
        spacing: MonAISpacing.x1,
        children: List.generate(segments.length, (index) {
          final segment = segments[index];
          return Expanded(
            child: _SegmentButton<T>(
              segment: segment,
              selected: segment.value == selected,
              onTap: () => onChanged(segment.value),
            ),
          );
        }),
      ),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final MonAISegment<T> segment;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final container = selected
        ? segment.selectedContainer ?? c.surface
        : Colors.transparent;
    final content = selected
        ? segment.selectedContent ?? c.textPrimary
        : c.textTertiary;
    return Semantics(
      selected: selected,
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: MonAIRadius.fullAll,
          boxShadow: selected && !c.isDark
              ? const [
                  BoxShadow(
                    color: Color(0x14101828),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: container,
          shape: const StadiumBorder(),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                segment.label,
                maxLines: 1,
                overflow: .ellipsis,
                style: context.textTheme.labelLarge?.copyWith(color: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
