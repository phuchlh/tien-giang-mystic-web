class SampleModel {
  String? idSample;
  String? nameSample;

  SampleModel({
    this.idSample,
    this.nameSample,
  });

  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      idSample: json['idSample'] as String?,
      nameSample: json['nameSample'] as String?,
    );
  }
}
