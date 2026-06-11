import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/doc_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';

class DocItemMapper {
  static Doc mapDTO(DocDTO data) => Doc(
        id: data.id,
        title: data.title,
        comment: data.comment,
        created: data.created,
        fileName: data.fileName,
        fullName: data.fullName,
        fileSize: data.fileSize,
        documentType: data.documentType,
        pathFile: data.pathFile,
        documentDate: data.documentDate,
        expireDate: data.expireDate,
        documentFileTypeId: data.documentFileTypeId,
        documentFileTypeTitle: data.documentFileTypeTitle,
        docType: data.docType,
        contentType: data.contentType ?? '',
        published: data.published ?? false,
        elementOrderNum: data.elementOrderNum,
        protocolElementId: data.protocolElementId,
      );
}
