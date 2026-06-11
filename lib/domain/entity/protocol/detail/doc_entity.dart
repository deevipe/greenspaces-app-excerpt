class Doc {
  final int id;
  final String? title;
  final String? comment;
  final String? created;
  final String? fileName;
  final String? fullName;
  final String? fileSize;
  final String documentType;
  final String pathFile;
  final String? documentDate;
  final String? expireDate;
  final int? documentFileTypeId;
  final String? documentFileTypeTitle;
  final int? docType;
  final String contentType;
  final bool published;
  final int? elementOrderNum;
  final int? protocolElementId;

  Doc({
    required this.id,
    this.comment,
    this.title,
    this.created,
    this.fileName,
    this.fullName,
    this.fileSize,
    required this.documentType,
    required this.pathFile,
    this.documentDate,
    this.expireDate,
    this.documentFileTypeId,
    this.documentFileTypeTitle,
    this.docType,
    required this.contentType,
    required this.published,
    this.elementOrderNum,
    this.protocolElementId,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json['id'],
        documentType: json['documentType'],
        pathFile: json['pathFile'],
        comment: json['comment'],
        title: json['title'],
        created: json['created'],
        fileName: json['fileName'],
        fullName: json['fullName'],
        fileSize: json['fileSize'],
        documentDate: json['documentDate'],
        expireDate: json['expireDate'],
        documentFileTypeId: json['documentFileTypeId'],
        documentFileTypeTitle: json['documentFileTypeTitle'],
        docType: json['docType'],
        contentType: json['contentType'],
        published: json['published'],
        elementOrderNum: json['elementOrderNum'],
        protocolElementId: json['protocolElementId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
        'title': title,
        'created': created,
        'fileName': fileName,
        'fullName': fullName,
        'fileSize': fileSize,
        'documentType': documentType,
        'pathFile': pathFile,
        'documentDate': documentDate,
        'expireDate': expireDate,
        'documentFileTypeId': documentFileTypeId,
        'documentFileTypeTitle': documentFileTypeTitle,
        'docType': docType,
        'contentType': contentType,
        'published': published,
        'elementOrderNum': elementOrderNum,
        'protocolElementId': protocolElementId,
      };
}
