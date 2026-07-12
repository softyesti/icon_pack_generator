/// Represents an icon (glyph).
class IconEntity {
  /// Creates a new [IconEntity].
  const IconEntity({
    required this.code,
    required this.name,
    required this.data,
  });

  /// Code point.
  final int code;

  /// Name.
  final String name;

  /// SVG data.
  final String data;
}
