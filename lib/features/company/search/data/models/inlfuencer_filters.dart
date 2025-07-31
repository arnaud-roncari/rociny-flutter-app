class InfluencerFilters {
  List<String> themes;
  List<String> departments;
  List<String> ages;
  List<String> targets;
  List<int> followersRange;
  List<double> engagementRateRange;

  InfluencerFilters({
    this.themes = const [],
    this.departments = const [],
    this.ages = const [],
    this.targets = const [],
    this.followersRange = const [0, 2000000],
    this.engagementRateRange = const [0, 20],
  });

  factory InfluencerFilters.empty() {
    return InfluencerFilters(
      themes: [],
      departments: [],
      ages: [],
      targets: [],
      followersRange: [],
      engagementRateRange: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themes': themes.isNotEmpty ? themes : null,
      'departments': departments.isNotEmpty ? departments : null,
      'ages': ages.isNotEmpty ? ages : null,
      'targets': targets.isNotEmpty ? targets : null,
      'followersRange': followersRange.isNotEmpty ? followersRange : null,
      'engagementRateRange': engagementRateRange.isNotEmpty ? engagementRateRange : null,
    };
  }

  String summarise() {
    final parts = <String>[];

    if (themes.isNotEmpty) parts.add(themes.join(', '));
    if (departments.isNotEmpty) parts.add(departments.join(', '));
    if (ages.isNotEmpty) parts.add(ages.join(', '));
    if (targets.isNotEmpty) parts.add(targets.join(', '));
    if (followersRange.length == 2) {
      parts.add('${followersRange[0]} - ${followersRange[1]}');
    }

    if (engagementRateRange.length == 2) {
      parts.add('${engagementRateRange[0].toStringAsFixed(0)} - ${engagementRateRange[1].toStringAsFixed(0)}%');
    }

    return parts.join(', ');
  }
}
