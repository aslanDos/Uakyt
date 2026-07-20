import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uakyt/core/extensions/theme_x.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    this.itemSize = 32,
    this.spacing = 0,
    required this.selectedIndex,
    required this.colors,
    required this.onChanged,
  });

  final double itemSize;
  final double spacing;
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late final ScrollController _controller;

  late int _selectedIndex;
  bool _isSettling = false;

  static const double _selectedScale = 1.2;

  double get _itemSlotSize => widget.itemSize * _selectedScale;

  double get _itemExtent => _itemSlotSize + widget.spacing;

  int _nearestIndex() {
    return (_controller.offset / _itemExtent).round().clamp(
      0,
      widget.colors.length - 1,
    );
  }

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.selectedIndex;
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onScroll() {
    final index = _nearestIndex();

    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      HapticFeedback.selectionClick();
    }
  }

  Future<void> _scrollTo(int index) async {
    if (!_controller.hasClients) {
      return;
    }

    final target = (index * _itemExtent).clamp(
      _controller.position.minScrollExtent,
      _controller.position.maxScrollExtent,
    );

    if ((_controller.offset - target).abs() < 0.5) {
      return;
    }

    await _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _commitSelectedIndex(int index) {
    if (index != widget.selectedIndex) {
      widget.onChanged(index);
    }
  }

  Future<void> _settleAndCommit() async {
    if (_isSettling) {
      return;
    }

    _isSettling = true;

    final index = _nearestIndex();

    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }

    await Future<void>.delayed(Duration.zero);

    if (!mounted) {
      return;
    }

    await _scrollTo(index);

    if (!mounted) {
      return;
    }

    _commitSelectedIndex(index);
    _isSettling = false;
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification && !_isSettling) {
      _settleAndCommit();
    }

    return false;
  }

  Future<void> _onColorTap(int index) async {
    if (_isSettling) {
      return;
    }

    _isSettling = true;

    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }

    await _scrollTo(index);

    if (!mounted) {
      return;
    }

    _commitSelectedIndex(index);
    _isSettling = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 70,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = (constraints.maxWidth - _itemSlotSize) / 2;

          return NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: ListView.separated(
              separatorBuilder: (_, _) => SizedBox(width: widget.spacing),
              controller: _controller,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemCount: widget.colors.length,
              itemBuilder: (context, index) {
                final selected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => _onColorTap(index),
                  child: SizedBox(
                    width: _itemSlotSize,
                    child: Center(
                      child: AnimatedSlide(
                        offset: selected ? const Offset(0, -0.2) : .zero,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: AnimatedScale(
                          scale: selected ? _selectedScale : 1.0,
                          alignment: Alignment.center,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            width: widget.itemSize,
                            height: widget.itemSize,
                            decoration: BoxDecoration(
                              color: widget.colors[index],
                              shape: .rectangle,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
