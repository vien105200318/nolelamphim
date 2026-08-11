import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import 'share_button.dart' show kSiteUrl, kContactEmail;

const _issues = <String>[
  'Không xem được / lỗi phát',
  'Sai tập / sai phim',
  'Lỗi phụ đề',
  'Sai poster / ảnh',
  'Khác',
];

/// Nút "Báo lỗi" + modal glass (spec §4.12): 5 loại lỗi (mục đầu active =
/// gradient + border tím), textarea ghi chú, nút Huỷ / Gửi báo lỗi → mở mail.
class ReportButton extends StatefulWidget {
  final String slug;
  final String name;
  final String? episode;

  /// Khi `true`: nút trải full-width, kiểu phẳng (dùng bên trong liquid glass panel).
  final bool fullWidth;

  const ReportButton({
    super.key,
    required this.slug,
    required this.name,
    this.episode,
    this.fullWidth = false,
  });

  @override
  State<ReportButton> createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  int _issue = 0;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _open() {
    setState(() {
      _issue = 0;
      _noteController.clear();
    });
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: _ReportCard(
          selected: _issue,
          onSelect: (i) => setState(() => _issue = i),
          controller: _noteController,
          onCancel: () => Navigator.of(ctx).pop(),
          onSubmit: () => _submit(ctx),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext dialogContext) async {
    final subject = '[Báo lỗi] ${widget.name}';
    final episodeLine = widget.episode == null || widget.episode!.isEmpty
        ? ''
        : 'Tập: ${widget.episode}\n';
    final body = 'Phim: ${widget.name}\n'
        '$episodeLine'
        'Liên kết: $kSiteUrl/phim/${widget.slug}\n'
        'Vấn đề: ${_issues[_issue]}\n'
        '${_noteController.text.trim().isEmpty ? '' : 'Ghi chú: ${_noteController.text.trim()}\n'}';
    final uri = Uri(
      scheme: 'mailto',
      path: kContactEmail,
      query: 'subject=${Uri.encodeComponent(subject)}'
          '&body=${Uri.encodeComponent(body)}',
    );
    if (await launchUrl(uri)) {
      if (dialogContext.mounted) Navigator.of(dialogContext).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      child: Container(
        height: widget.fullWidth ? 40 : 36,
        width: widget.fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x17FFFFFF), Color(0x06FFFFFF)],
          ),
          color: AppColors.glassBackdrop,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment:
              widget.fullWidth ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: const [
            Icon(Icons.flag_outlined, size: 15, color: AppColors.textSecondary),
            SizedBox(width: 6),
            Text(
              'Báo lỗi',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const _ReportCard({
    required this.selected,
    required this.onSelect,
    required this.controller,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x17FFFFFF), Color(0x08FFFFFF)],
        ),
        color: AppColors.glassBackdrop,
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Báo lỗi phim',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _issues.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: selected == i
                        ? const LinearGradient(
                            colors: [
                              Color(0x26FF6B9D),
                              Color(0x264A9EFF),
                            ],
                          )
                        : null,
                    color: selected == i ? null : Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: selected == i
                          ? AppColors.gradientMid.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    _issues[i],
                    style: TextStyle(
                      color: selected == i
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gradientMid.withValues(alpha: 0.2),
              ),
            ),
            child: TextField(
              controller: controller,
              maxLines: 3,
              minLines: 3,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.5,
              ),
              decoration: InputDecoration(
                hintText: 'Ghi chú thêm (không bắt buộc)...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Huỷ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: onSubmit,
                  child: Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientMid,
                          AppColors.gradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gradientMid.withValues(alpha: 0.25),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Gửi báo lỗi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
