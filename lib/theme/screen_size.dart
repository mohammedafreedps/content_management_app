class ScreenSize {
  final double width;
  final double height;

  const ScreenSize({
    required this.width,
    required this.height,
  });

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;
}
