import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/workshop_session.dart';

class VideoPlayerModal extends StatefulWidget {
  const VideoPlayerModal({
    super.key,
    required this.session,
    required this.onClose,
  });

  final WorkshopSession session;
  final VoidCallback onClose;

  @override
  State<VideoPlayerModal> createState() => _VideoPlayerModalState();
}

class _VideoPlayerModalState extends State<VideoPlayerModal> {
  bool _isPlaying = true;
  double _playbackPosition = 0.25; // 25% progress

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final session = widget.session;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: GdgShapes.sheetTop,
          ),
          child: Column(
            children: [
              // Drag Handle
              const SizedBox(height: GdgSpacing.sp3),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: GdgShapes.full,
                ),
              ),
              const SizedBox(height: GdgSpacing.sp3),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: GdgSpacing.sp5,
                  ),
                  children: [
                    // Header Bar with Close Button
                    Row(
                      children: [
                        GdgChipAssist(
                          label: session.category,
                          tone: GdgChipTone.blue,
                        ),
                        const SizedBox(width: GdgSpacing.sp2),
                        GdgChipAssist(
                          label: session.duration,
                          tone: GdgChipTone.neutral,
                          icon: const Icon(Icons.timer_outlined, size: 14),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: GdgSpacing.sp3),

                    // Interactive Video Player Frame
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: GdgShapes.lg,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Gradient Background Pattern
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colors.brandBlue.withValues(alpha: 0.3),
                                    colors.brandGreen.withValues(alpha: 0.2),
                                    Colors.black87,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Live playback badge
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0x99000000),
                                borderRadius: GdgShapes.sm,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _isPlaying
                                          ? colors.brandRed
                                          : colors.onSurface3,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isPlaying ? 'PLAYING PREVIEW' : 'PAUSED',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Central Play / Pause Controller
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _isPlaying = !_isPlaying),
                              borderRadius: GdgShapes.full,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),

                          // Bottom Controls Bar with Scrubber
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xCC000000),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 3,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                      activeTrackColor: colors.brandBlue,
                                      inactiveTrackColor: Colors.white24,
                                      thumbColor: Colors.white,
                                    ),
                                    child: Slider(
                                      value: _playbackPosition,
                                      onChanged: (val) => setState(
                                        () => _playbackPosition = val,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${(_playbackPosition * 45).toInt().toString().padLeft(2, '0')}:15',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        session.duration,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: GdgSpacing.sp4),

                    // Session Info
                    Text(
                      session.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp1),
                    Text(
                      'Presented by ${session.speaker} · Recorded ${session.recordedDate}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface2,
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp3),

                    Text(
                      'About this session',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp1),
                    Text(
                      session.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface2,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: GdgSpacing.sp6),

                    // YouTube Action Button
                    GdgFilledButton(
                      isWide: true,
                      backgroundColor: colors.brandRed,
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.smart_display_rounded, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening ${session.videoUrl}'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('Watch on YouTube'),
                    ),
                    const SizedBox(height: GdgSpacing.sp4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
