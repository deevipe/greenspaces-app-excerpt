class TorisLayerEntity {
  final int id;
  final int? oid;
  final String? name;
  final String? address;
  final String? owner;
  final String? ebType;

  TorisLayerEntity({
    required this.id,
    this.oid,
    required this.name,
    required this.address,
    required this.owner,
    required this.ebType,
  });

  factory TorisLayerEntity.fromJson(Map<String, dynamic> json) => TorisLayerEntity(
        id: json['OBJECTID'],
        oid: json['OID'],
        name: json['NAME'] ?? json['НАЗВАНИЕ'],
        address: json['ADDRESS'] ?? json['АДРЕС'] ?? json['ADDRESS_EAS'],
        owner: json['OWNERORGUID'],
        ebType: json['EBTYPE'] ?? json['OBTYPEUID'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'oid': oid,
        'name': name,
        'address': address,
        'owner': owner,
        'ebType': ebType,
      };

  factory TorisLayerEntity.initial() => TorisLayerEntity(
        id: 0,
        name: null,
        address: null,
        owner: null,
        ebType: null,
      );
}
