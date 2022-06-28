class OnboardingContent {
  final String title;
  final String desc;

  final String image;

  OnboardingContent(
      {required this.title, required this.desc, required this.image});
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: "Data display",
    desc: "All the api data displayed in simple designed screen",
    image: "images/all_data.svg",
  ),
  OnboardingContent(
    title: "Code available",
    desc: "Find all easy to understand code nd use it as you please.",
    image: "images/code_shown.svg",
  ),
  OnboardingContent(
    title: "Take away",
    desc: "If you learn a thing or two , well then , great !",
    image: "images/take_away.svg",
  ),
];
