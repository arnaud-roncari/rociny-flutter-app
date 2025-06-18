enum PlatformType {
  twitch,
  youtube,
  x,
  linkedin,
  tiktok,
}

String getPlatformSvgAsset(PlatformType platform) {
  switch (platform) {
    case PlatformType.twitch:
      return 'assets/svg/twitch.svg';
    case PlatformType.youtube:
      return 'assets/svg/youtube.svg';
    case PlatformType.x:
      return 'assets/svg/x.svg';
    case PlatformType.linkedin:
      return 'assets/svg/linkedin.svg';
    case PlatformType.tiktok:
      return 'assets/svg/tiktok.svg';
  }
}

String getDisplayedName(PlatformType platform) {
  switch (platform) {
    case PlatformType.twitch:
      return 'Twitch';
    case PlatformType.youtube:
      return 'Youtube';
    case PlatformType.x:
      return 'X';
    case PlatformType.linkedin:
      return 'Linkedin';
    case PlatformType.tiktok:
      return 'Tiktok';
  }
}
