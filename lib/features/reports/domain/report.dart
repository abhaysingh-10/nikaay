class Report {
  final int id;
  final String fileUrl;
  final String filename;
  final int fileSize;
  final String fileType;
  final String uploadedAt;

  Report({
    required this.id,
    required this.fileUrl,
    required this.filename,
    required this.fileSize,
    required this.fileType,
    required this.uploadedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      fileUrl: json['file'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      fileType: json['file_type'] as String? ?? '',
      uploadedAt: json['uploaded_at'] as String? ?? '',
    );
  }
}
