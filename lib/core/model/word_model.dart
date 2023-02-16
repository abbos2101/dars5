class WordModel {
  final String uz;
  final String en;

  WordModel(this.uz, this.en);

  factory WordModel.empty() => WordModel("", "");

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(json["uz"] ?? "", json["en"] ?? "");
  }

  Map<String, dynamic> toJson() => {"uz": uz, "en": en};
}
