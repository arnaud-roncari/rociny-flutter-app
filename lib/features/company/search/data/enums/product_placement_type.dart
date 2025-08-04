/// TODO transalte
library;

enum ProductPlacementType {
  post,
  reel,
  story,
  giveaway;

  static ProductPlacementType fromString(String value) {
    return ProductPlacementType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid ProductPlacementType: $value'),
    );
  }

  String productPlacementTypeToString() {
    if (this == ProductPlacementType.post) {
      return "Post";
    }
    if (this == ProductPlacementType.reel) {
      return "Reel";
    }
    if (this == ProductPlacementType.story) {
      return "Story";
    }
    if (this == ProductPlacementType.giveaway) {
      return "Jeu concours";
    }
    return "";
  }

  String productPlacementsTypeToString() {
    if (this == ProductPlacementType.post) {
      return "posts";
    }
    if (this == ProductPlacementType.reel) {
      return "reels";
    }
    if (this == ProductPlacementType.story) {
      return "stories";
    }
    if (this == ProductPlacementType.giveaway) {
      return "jeu concours";
    }
    return "";
  }
}
