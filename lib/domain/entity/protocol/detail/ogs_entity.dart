class Ogs {
  final int? id;
  final String? name;
  final String? address;

  const Ogs({
    this.id,
    this.name,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
      };
}
