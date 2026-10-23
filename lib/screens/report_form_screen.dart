
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState {
  idle,
  loading,
  success,
  empty,
  error,
}

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() =>
      _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  static const Color teal = Color(0xFF087E8B);
  static const Color background = Color(0xFFF3F7F8);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _state = ReportUiState.idle;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _state = ReportUiState.loading);

    try {
      await Future<void>.delayed(
        const Duration(seconds: 3),
      );

      if (!mounted) return;
      setState(() => _state = ReportUiState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = ReportUiState.error);
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();

    setState(() => _state = ReportUiState.idle);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _state == ReportUiState.loading;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: const Color(0xFF19343A),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Report Center',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: teal,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        'Make your voice heard.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Share an issue or provide feedback '
                        'using the form below.',
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFE0EAEC),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A183B40),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF19343A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Complete both fields before submitting.',
                          style: TextStyle(
                            color: Color(0xFF71868A),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 24),

                        const _FieldHeading(
                          icon: Icons.short_text,
                          text: 'Report title',
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          label: 'Give your report a title',
                          controller: _titleController,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter a report title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),

                        const _FieldHeading(
                          icon: Icons.notes_outlined,
                          text: 'Description',
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          label: 'Describe the issue or feedback',
                          controller: _descriptionController,
                          maxLines: 4,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            text: isLoading
                                ? 'Submitting...'
                                : 'Send Report',
                            onPressed:
                                isLoading ? null : _submitReport,
                          ),
                        ),

                        if (_state == ReportUiState.loading)
                          const _StatusPanel(
                            icon: Icons.hourglass_top_rounded,
                            color: teal,
                            title: 'Sending your report',
                            message:
                                'Please wait while we process your submission.',
                            showProgress: true,
                          ),

                        if (_state == ReportUiState.success)
                          _StatusPanel(
                            icon: Icons.check_circle_outline,
                            color: Colors.green.shade700,
                            title: 'Report received!',
                            message:
                                'Your report was submitted successfully.',
                            actionLabel: 'Create another report',
                            onAction: _resetForm,
                          ),

                        if (_state == ReportUiState.empty)
                          _StatusPanel(
                            icon: Icons.inbox_outlined,
                            color: teal,
                            title: 'Nothing to show yet',
                            message:
                                'No reports are available at the moment.',
                            actionLabel: 'Start a report',
                            onAction: _resetForm,
                          ),

                        if (_state == ReportUiState.error)
                          _StatusPanel(
                            icon: Icons.warning_amber_rounded,
                            color: Colors.red.shade700,
                            title: 'Submission unsuccessful',
                            message:
                                'Something went wrong. Please try again.',
                            actionLabel: 'Try again',
                            onAction: () {
                              setState(
                                () => _state = ReportUiState.idle,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F1F2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: teal,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Demo controls are provided for testing '
                          'the Empty and Error interface states.',
                          style: TextStyle(
                            color: Color(0xFF42666B),
                            height: 1.45,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => setState(
                                () => _state = ReportUiState.empty,
                              ),
                      icon: const Icon(Icons.inbox_outlined),
                      label: const Text('Test Empty'),
                    ),
                    OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => setState(
                                () => _state = ReportUiState.error,
                              ),
                      icon: const Icon(Icons.error_outline),
                      label: const Text('Test Error'),
                    ),
                    TextButton.icon(
                      onPressed: isLoading ? null : _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset form'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldHeading extends StatelessWidget {
  const _FieldHeading({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: const Color(0xFF087E8B),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF19343A),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.showProgress = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          if (showProgress)
            CircularProgressIndicator(color: color)
          else
            Icon(icon, color: color, size: 34),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF52696D),
              height: 1.4,
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
