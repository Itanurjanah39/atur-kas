class TransaksiModel {
  final String id;
  final DateTime tanggal;
  final String keterangan;
  final double nominal;
  final String tipe;
  final String? kategori;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransaksiModel({
    required this.id,
    required this.tanggal,
    required this.keterangan,
    required this.nominal,
    required this.tipe,
    this.kategori,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id'] as String,
      tanggal: DateTime.parse(json['tanggal'] as String),
      keterangan: json['keterangan'] as String,
      nominal: (json['nominal'] as num).toDouble(),
      tipe: json['tipe'] as String,
      kategori: json['kategori'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'keterangan': keterangan,
      'nominal': nominal,
      'tipe': tipe,
      'kategori': kategori,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TransaksiModel copyWith({
    String? id,
    DateTime? tanggal,
    String? keterangan,
    double? nominal,
    String? tipe,
    String? kategori,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransaksiModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      keterangan: keterangan ?? this.keterangan,
      nominal: nominal ?? this.nominal,
      tipe: tipe ?? this.tipe,
      kategori: kategori ?? this.kategori,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
