
import 'package:boycott_subscription/Lyrics/id&lrc_convertor.dart';
import 'package:flutter/material.dart';

class CenterLyricsView extends StatefulWidget {
  final List<LyricLine> lyrics;
  final Duration position;
  final Color color;

  const CenterLyricsView({
    super.key,
    required this.lyrics,
    required this.position, 
    required this.color,
  });

  @override
  State<CenterLyricsView> createState() => _CenterLyricsViewState();
}

class _CenterLyricsViewState extends State<CenterLyricsView> {
  int _lastIndex = 0;

  int _getActiveIndex() {
    for (int i = 0; i < widget.lyrics.length - 1; i++) {
      if (widget.position >= widget.lyrics[i].timestamp &&
          widget.position < widget.lyrics[i + 1].timestamp) {
        return i;
      }
    }
    return widget.lyrics.isNotEmpty
        ? 0
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyrics.isEmpty) {
      return Center(
        child:  Text(
          "No Lyrics Available",
          style: TextStyle(color:widget. color , fontWeight: FontWeight.bold,fontSize: 20 ),
        ),
      );
    }

    final activeIndex = _getActiveIndex();
    final isForward = activeIndex >= _lastIndex;
    _lastIndex = activeIndex;

    
    final current = widget.lyrics[activeIndex].text ;
    final next = activeIndex < widget.lyrics.length - 1
        ? widget.lyrics[activeIndex + 1].text
        : "";

    return SizedBox(
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          const SizedBox(height: 10),

          _seamlessLine(
            text: current,
            isActive: true,
            isForward: isForward,
          ),
          const SizedBox(height: 10),

          _seamlessLine(
            text: next,
            isActive: false,
            isForward: isForward,
          ),
        ],
      ),
    );
  }

  Widget _seamlessLine({
    required String text,
    required bool isActive,
    required bool isForward,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        final offset = Tween<Offset>(
          begin: isForward ? const Offset(0, 0.2) : const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(animation);

        return ClipRect(
          child: SlideTransition(
            position: offset,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      child: AnimatedDefaultTextStyle(
        key: ValueKey(text), // ✅ THIS IS THE SECRET FOR SEAMLESS SHIFT
        duration: const Duration(milliseconds: 220),
        style: TextStyle(
          fontSize: isActive ? 20 : 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? widget. color : Colors.grey.shade500,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: isActive ? 2 :1 ,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}


