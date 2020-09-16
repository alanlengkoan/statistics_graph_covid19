class ListApiProvinsi {
  final int fid;
  final int kodeProvi;
  final String provinsi;
  final int kasusPosi;
  final int kasusSemb;
  final int kasusMeni;

  ListApiProvinsi({
    this.fid,
    this.kodeProvi,
    this.provinsi,
    this.kasusPosi,
    this.kasusSemb,
    this.kasusMeni,
  });

  factory ListApiProvinsi.fromJson(Map<String, dynamic> json) {
    return ListApiProvinsi(
      fid: json['fid'],
      kodeProvi: json['kodeProvi'],
      provinsi: json['provinsi'],
      kasusPosi: json['kasusPosi'],
      kasusSemb: json['kasusSemb'],
      kasusMeni: json['kasusMeni'],
    );
  }
}
