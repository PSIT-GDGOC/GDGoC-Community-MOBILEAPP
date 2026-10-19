import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/manage_event_item.dart';

/// Bottom sheet dialog for creating or editing an event in Screen 13.
class CreateEditEventSheet extends StatefulWidget {
  const CreateEditEventSheet({
    super.key,
    this.initialEvent,
    required this.onSave,
  });

  final ManageEventItem? initialEvent;
  final ValueChanged<ManageEventItem> onSave;

  static Future<void> show(
    BuildContext context, {
    ManageEventItem? initialEvent,
    required ValueChanged<ManageEventItem> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateEditEventSheet(
        initialEvent: initialEvent,
        onSave: onSave,
      ),
    );
  }

  @override
  State<CreateEditEventSheet> createState() => _CreateEditEventSheetState();
}

class _CreateEditEventSheetState extends State<CreateEditEventSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _venueController;
  late final TextEditingController _totalSeatsController;
  late final TextEditingController _registeredSeatsController;
  late bool _isLiveNow;
  late bool _isPast;

  @override
  void initState() {
    super.initState();
    final e = widget.initialEvent;
    _titleController = TextEditingController(text: e?.title ?? '');
    _dateController = TextEditingController(text: e?.date ?? 'Sat 24 Oct');
    _timeController = TextEditingController(text: e?.time ?? '11:00 AM');
    _venueController = TextEditingController(text: e?.venue ?? 'Seminar Hall');
    _totalSeatsController =
        TextEditingController(text: e != null ? '${e.totalSeats}' : '100');
    _registeredSeatsController =
        TextEditingController(text: e != null ? '${e.registeredSeats}' : '0');
    _isLiveNow = e?.isLiveNow ?? false;
    _isPast = e?.isPast ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _totalSeatsController.dispose();
    _registeredSeatsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final totalSeats = int.tryParse(_totalSeatsController.text.trim()) ?? 100;
    final registeredSeats =
        int.tryParse(_registeredSeatsController.text.trim()) ?? 0;

    final event = ManageEventItem(
      id: widget.initialEvent?.id ?? '',
      title: _titleController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      venue: _venueController.text.trim(),
      totalSeats: totalSeats,
      registeredSeats: registeredSeats,
      isLiveNow: _isLiveNow,
      isPast: _isPast,
      statusTone: registeredSeats >= totalSeats
          ? GdgChipTone.yellow
          : GdgChipTone.blue,
      icon: widget.initialEvent?.icon ?? Icons.event_outlined,
    );

    widget.onSave(event);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final isEditing = widget.initialEvent != null;

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: EdgeInsets.only(
        top: GdgSpacing.sp4,
        left: GdgSpacing.sp5,
        right: GdgSpacing.sp5,
        bottom: MediaQuery.of(context).viewInsets.bottom + GdgSpacing.sp6,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outline,
                      borderRadius: GdgShapes.full,
                    ),
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp4),

                // Title
                Row(
                  children: [
                    Text(
                      isEditing ? 'Edit Event' : 'New Event',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: GdgSpacing.sp4),

                // Event Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    hintText: 'e.g. Flutter Forward Extended',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: GdgSpacing.sp3),

                // Date & Time Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          hintText: 'Sat 24 Oct',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                    ),
                    const SizedBox(width: GdgSpacing.sp3),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          hintText: '11:00 AM',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: GdgSpacing.sp3),

                // Venue Field
                TextFormField(
                  controller: _venueController,
                  decoration: const InputDecoration(
                    labelText: 'Venue',
                    hintText: 'e.g. Seminar Hall / Lab 4',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: GdgSpacing.sp3),

                // Seats Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _totalSeatsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Total Capacity',
                          hintText: '150',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || int.tryParse(val.trim()) == null) {
                            return 'Enter valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: GdgSpacing.sp3),
                    Expanded(
                      child: TextFormField(
                        controller: _registeredSeatsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Registered Seats',
                          hintText: '0',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || int.tryParse(val.trim()) == null) {
                            return 'Enter valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: GdgSpacing.sp3),

                // Live Now Switch
                SwitchListTile(
                  title: const Text('Live now (Active event)'),
                  subtitle: const Text('Shows live indicator on cards & badges'),
                  value: _isLiveNow,
                  onChanged: (val) => setState(() => _isLiveNow = val),
                  contentPadding: EdgeInsets.zero,
                ),

                // Past Event Switch
                SwitchListTile(
                  title: const Text('Mark as Past Event'),
                  subtitle: const Text('Moves event to Past events tab'),
                  value: _isPast,
                  onChanged: (val) => setState(() => _isPast = val),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: GdgSpacing.sp4),

                // Submit Button
                GdgFilledButton(
                  isWide: true,
                  onPressed: _submit,
                  child: Text(isEditing ? 'Save Changes' : 'Create Event'),
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
