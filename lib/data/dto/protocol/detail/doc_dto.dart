class DocDTO {
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
  final String? contentType;
  final bool? published;
  final int? elementOrderNum;
  final int? protocolElementId;

  DocDTO({
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

  factory DocDTO.fromJson(Map<String, dynamic> json) => DocDTO(
        id: json['Id'],
        comment: json['Comment'],
        title: json['Title'],
        created: json['Created'],
        fileName: json['FileName'],
        fullName: json['FullName'],
        fileSize: json['FileSize'],
        documentType: json['DocumentType'],
        pathFile: json['PathFile'],
        documentDate: json['DocumentDate'],
        expireDate: json['ExpireDate'],
        documentFileTypeId: json['DocumentFileTypeId'],
        documentFileTypeTitle: json['DocumentFileTypeTitle'],
        docType: json['DocType'],
        contentType: json['ContentType'],
        published: json['Published'],
        elementOrderNum: json['ElementOrderNum'],
        protocolElementId: json['ProtocolElementId'],
      );
}
