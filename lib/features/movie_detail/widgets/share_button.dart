import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';

const String kSiteUrl = 'https://nolelamphim.vercel.app';
const String kContactEmail = 'contact@nolelamphim.vercel.app';

/// Nút chia sẻ + popover glass (spec §4.13): "Copy liên kết" → "Đã copy!",
/// "Chia sẻ Facebook".
class ShareButton extends StatefulWidget {
  final String slug;
  final String name;

  const ShareButton({super.key, required this.slug, required this.name});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;

  String get _url => '$kSiteUrl/phim/${widget.slug}';

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  void _toggle() {
    if (_entry != null) {
      _hide();
      return;
    }
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (ctx) => Positioned(
        width: 190,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.topRight,
          showWhenUnlinked: false,
          offset: const Offset(0, 44),
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _hide,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x17FFFFFF), Color(0x08FFFFFF)],
                  ),
                  color: AppColors.glassBackdrop,
                  border: Border.all(color: AppColors.glassBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ShareOption(
                      icon: Icons.copy_rounded,
                      label: 'Copy liên kết',
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: _url));
                        if (ctx.mounted) AppToast.show(ctx, 'Đã copy!');
                        _hide();
                      },
                    ),
                    _ShareOption(
                      icon: Icons.facebook,
                      label: 'Chia sẻ Facebook',
                      onTap: () {
                        final url =
                            'https://www.facebook.com/sharer/sharer.php?u='
                            '${Uri.encodeComponent(_url)}';
                        launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                        _hide();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x17FFFFFF), Color(0x06FFFFFF)],
            ),
            color: AppColors.glassBackdrop,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: const Icon(
            Icons.share_outlined,
            size: 17,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
