enum PlatformType {
  twitch,
  youtube,
  x,
  linkedin,
  tiktok,
  instagram,
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
    case PlatformType.instagram:
      return 'assets/svg/instagram.svg';
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
    case PlatformType.instagram:
      return 'Instagram';
  }
}

String getPlatformBaseUrl(PlatformType platform) {
  switch (platform) {
    case PlatformType.twitch:
      return 'https://www.twitch.tv/';
    case PlatformType.youtube:
      return 'https://www.youtube.com/';
    case PlatformType.x:
      return 'https://x.com/';
    case PlatformType.linkedin:
      return 'https://www.linkedin.com/in/';
    case PlatformType.tiktok:
      return 'https://www.tiktok.com/@';
    case PlatformType.instagram:
      return 'https://www.instagram.com/';
  }
}
