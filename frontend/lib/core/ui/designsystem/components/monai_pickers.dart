import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/components/monai_badges.dart';
import 'package:monai/core/ui/designsystem/components/monai_button.dart';
import 'package:monai/core/ui/designsystem/components/monai_calendar.dart';
import 'package:monai/core/ui/designsystem/components/monai_feedback.dart';
import 'package:monai/core/ui/designsystem/components/monai_list_items.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';

@immutable
class MonAIRadioPickerOption {
  const MonAIRadioPickerOption({
    required this.id,
    required this.title,
    this.subtitle,
    this.tag,
    this.leading,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? tag;
  final Widget? leading;
}

class MonAIRadioPickerSheet extends StatefulWidget {
  const MonAIRadioPickerSheet({
    required this.options,
    required this.selectedId,
    required this.onPick,
    required this.doneLabel,
    super.key,
    this.note,
  });

  final List<MonAIRadioPickerOption> options;
  final String? selectedId;
  final ValueChanged<String> onPick;
  final String doneLabel;
  final String? note;

  @override
  State<MonAIRadioPickerSheet> createState() => _MonAIRadioPickerSheetState();
}

class _MonAIRadioPickerSheetState extends State<MonAIRadioPickerSheet> {
  late final _selected = ValueNotifier<String?>(widget.selectedId);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pick(String id) => _selected.value = id;

  void _done() {
    if (_selected.value case final id?) widget.onPick(id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3_5,
      children: [
        Flexible(
          child: ValueListenableBuilder(
            valueListenable: _selected,
            builder: (context, selected, _) => ListView.separated(
              shrinkWrap: true,
              itemCount: widget.options.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: MonAISpacing.x2),
              itemBuilder: (context, index) {
                final option = widget.options[index];
                return MonAIRadioOption(
                  title: option.title,
                  subtitle: option.subtitle,
                  tag: option.tag,
                  leading: option.leading,
                  selected: selected == option.id,
                  onTap: () => _pick(option.id),
                );
              },
            ),
          ),
        ),
        if (widget.note case final note?)
          Text(
            note,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
        MonAIButton(label: widget.doneLabel, onPressed: _done, expand: true),
      ],
    );
  }
}

@immutable
class MonAICategoryOption {
  const MonAICategoryOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final MonAIIconData icon;
  final Color color;
}

class MonAICategoryPickerSheet extends StatefulWidget {
  const MonAICategoryPickerSheet({
    required this.options,
    required this.selectedId,
    required this.onPick,
    required this.doneLabel,
    required this.useLabel,
    required this.emptyLabel,
    super.key,
  });

  final List<MonAICategoryOption> options;
  final String? selectedId;
  final ValueChanged<String> onPick;
  final String doneLabel;
  final String Function(String name) useLabel;
  final String emptyLabel;

  @override
  State<MonAICategoryPickerSheet> createState() =>
      _MonAICategoryPickerSheetState();
}

class _MonAICategoryPickerSheetState extends State<MonAICategoryPickerSheet> {
  late final _selected = ValueNotifier<String?>(widget.selectedId);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pick(String id) => _selected.value = id;

  void _use(String id) {
    widget.onPick(id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return Padding(
        padding: const .symmetric(vertical: MonAISpacing.x6),
        child: Text(widget.emptyLabel, textAlign: .center),
      );
    }
    return ValueListenableBuilder(
      valueListenable: _selected,
      builder: (context, selected, _) {
        final chosen = widget.options
            .where((option) => option.id == selected)
            .firstOrNull;
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x4,
          children: [
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: MonAISpacing.x4,
                  crossAxisSpacing: MonAISpacing.x2,
                  mainAxisExtent: 84,
                ),
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return _CategoryTile(
                    option: option,
                    selected: option.id == selected,
                    onTap: () => _pick(option.id),
                  );
                },
              ),
            ),
            MonAIButton(
              label: chosen == null
                  ? widget.doneLabel
                  : widget.useLabel(chosen.name),
              onPressed: chosen == null ? null : () => _use(chosen.id),
              expand: true,
            ),
          ],
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final MonAICategoryOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: MonAIRadius.mdAll,
        child: Column(
          spacing: MonAISpacing.x1_5,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: .circle,
                border: Border.all(
                  color: selected ? c.focus : Colors.transparent,
                  width: MonAISizes.borderFocused,
                ),
              ),
              child: Padding(
                padding: const .all(MonAISpacing.x0_5),
                child: MonAICategoryIcon(
                  icon: option.icon,
                  color: option.color,
                  size: MonAISizes.avatarLarge - MonAISpacing.x2,
                ),
              ),
            ),
            Text(
              option.name,
              textAlign: .center,
              maxLines: 2,
              overflow: .ellipsis,
              style: context.textTheme.labelMedium?.copyWith(
                color: c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class MonAIDatePickerLabels {
  const MonAIDatePickerLabels({
    required this.title,
    required this.dateText,
    required this.today,
    required this.yesterday,
    required this.dayUnavailable,
    required this.futureNote,
    required this.cancel,
    required this.set,
  });

  final String title;
  final String Function(DateTime date) dateText;
  final String today;
  final String yesterday;
  final String Function(String date) dayUnavailable;
  final String futureNote;
  final String cancel;
  final String set;
}

class MonAIDatePickerSheet extends StatefulWidget {
  const MonAIDatePickerSheet({
    required this.selected,
    required this.today,
    required this.onPick,
    required this.labels,
    super.key,
  });

  final DateTime selected;
  final DateTime today;
  final ValueChanged<DateTime> onPick;
  final MonAIDatePickerLabels labels;

  @override
  State<MonAIDatePickerSheet> createState() => _MonAIDatePickerSheetState();
}

class _MonAIDatePickerSheetState extends State<MonAIDatePickerSheet> {
  late final _today = DateUtils.dateOnly(widget.today);
  late final _selected = ValueNotifier<DateTime>(
    DateUtils.dateOnly(widget.selected),
  );
  late final _shownMonth = ValueNotifier<DateTime>(_monthOf(widget.selected));

  @override
  void dispose() {
    _selected.dispose();
    _shownMonth.dispose();
    super.dispose();
  }

  static DateTime _monthOf(DateTime date) => DateTime(date.year, date.month);

  void _pick(DateTime date) => _selected.value = DateUtils.dateOnly(date);

  void _jumpTo(DateTime date) {
    _pick(date);
    _shownMonth.value = _monthOf(date);
  }

  void _pickToday() => _jumpTo(_today);

  void _pickYesterday() =>
      _jumpTo(DateTime(_today.year, _today.month, _today.day - 1));

  void _showMonth(DateTime month) => _shownMonth.value = month;

  void _cancel() => Navigator.pop(context);

  void _set() {
    widget.onPick(_selected.value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.labels;
    final c = context.colors;
    return ValueListenableBuilder(
      valueListenable: _selected,
      builder: (context, selected, _) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x3_5,
        children: [
          Column(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x0_5,
            children: [
              Text(
                labels.title,
                style: context.textTheme.labelMedium?.copyWith(
                  color: c.textSecondary,
                ),
              ),
              Text(
                labels.dateText(selected),
                style: context.textTheme.headlineSmall,
              ),
            ],
          ),
          Row(
            spacing: MonAISpacing.x2,
            children: [
              MonAIButton(
                label: labels.today,
                onPressed: _pickToday,
                variant: .outlined,
                size: .small,
              ),
              MonAIButton(
                label: labels.yesterday,
                onPressed: _pickYesterday,
                variant: .outlined,
                size: .small,
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: _shownMonth,
            builder: (context, shownMonth, _) => MonAICalendar(
              selected: selected,
              shownMonth: shownMonth,
              today: _today,
              onSelect: _pick,
              onShowMonth: _showMonth,
              dayUnavailableLabel: labels.dayUnavailable,
            ),
          ),
          Row(
            spacing: MonAISpacing.x1_5,
            children: [
              MonAIIcon(
                MonAIIcons.block,
                size: MonAISizes.iconSm,
                color: c.textTertiary,
              ),
              Text(
                labels.futureNote,
                style: context.textTheme.bodySmall?.copyWith(
                  color: c.textTertiary,
                ),
              ),
            ],
          ),
          MonAISheetButtons(
            secondaryLabel: labels.cancel,
            onSecondary: _cancel,
            primaryLabel: labels.set,
            onPrimary: _set,
          ),
        ],
      ),
    );
  }
}
