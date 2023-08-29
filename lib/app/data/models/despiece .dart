class Despiece {
  String material;
  String brand;
  String thickness;
  String colorQuality;
  PiecesCount piecesCount;
  Hitch hitch;
  Drilling drilling;
  Slot slot;

  Despiece({
    required this.material,
    required this.brand,
    required this.thickness,
    required this.colorQuality,
    required this.piecesCount,
    required this.hitch,
    required this.drilling,
    required this.slot,
  });

  Map<String, dynamic> toJson() {
    return {
      'material': material,
      'brand': brand,
      'thickness': thickness,
      'colorQuality': colorQuality,
      'piecesCount': piecesCount.toJson(),
      'hitch': hitch.toJson(),
      'drilling': drilling.toJson(),
      'slot': slot.toJson(),
    };
  }

  factory Despiece.fromJson(Map<String, dynamic> json) {
    return Despiece(
      material: json['material'],
      brand: json['brand'],
      thickness: json['Thickness'],
      colorQuality: json['color_quality'],
      piecesCount: PiecesCount.fromJson(json['pieces_count']),
      hitch: Hitch.fromJson(json['hitch']),
      drilling: Drilling.fromJson(json['drilling']),
      slot: Slot.fromJson(json['slot']),
    );
  }
}

class PiecesCount {
  List<String> amount;
  List<String> long;
  List<String> width;

  PiecesCount({
    required this.amount,
    required this.long,
    required this.width,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'long': long,
      'width': width,
    };
  }

  factory PiecesCount.fromJson(Map<String, dynamic> json) {
    return PiecesCount(
      amount: List<String>.from(json['amount']),
      long: List<String>.from(json['long']),
      width: List<String>.from(json['width']),
    );
  }
}

class Hitch {
  List<String> l1;
  List<String> l2;
  List<String> a1;

  Hitch({
    required this.l1,
    required this.l2,
    required this.a1,
  });

  Map<String, dynamic> toJson() {
    return {
      'l1': l1,
      'l2': l2,
      'a1': a1,
    };
  }

  factory Hitch.fromJson(Map<String, dynamic> json) {
    return Hitch(
      l1: List<String>.from(json['l1']),
      l2: List<String>.from(json['l2']),
      a1: List<String>.from(json['a1']),
    );
  }
}

class Drilling {
  List<String> amount;
  List<String> side;

  Drilling({
    required this.amount,
    required this.side,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'side': side,
    };
  }

  factory Drilling.fromJson(Map<String, dynamic> json) {
    return Drilling(
      amount: List<String>.from(json['amount']),
      side: List<String>.from(json['side']),
    );
  }
}

class Slot {
  List<String> side;
  List<String> distance;
  List<String> prof;
  List<String> es;

  Slot({
    required this.side,
    required this.distance,
    required this.prof,
    required this.es,
  });

  Map<String, dynamic> toJson() {
    return {
      'side': side,
      'distance': distance,
      'prof': prof,
      'es': es,
    };
  }

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      side: List<String>.from(json['side']),
      distance: List<String>.from(json['distance']),
      prof: List<String>.from(json['prof']),
      es: List<String>.from(json['es']),
    );
  }
}
