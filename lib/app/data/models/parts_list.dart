class PartItem {
  final String part;
  final String description;
  final String amount;
  final String long;
  final String broad;
  final String thickness;

  PartItem({
    required this.part,
    required this.description,
    required this.amount,
    required this.long,
    required this.broad,
    required this.thickness,
  });

  factory PartItem.fromJson(Map<String, dynamic> json) {
    return PartItem(
      part: json['part'],
      description: json['description'],
      amount: json['amount'],
      long: json['long'],
      broad: json['broad'],
      thickness: json['thickness'],
    );
  }
}

class Module {
  final String module;
  final List<PartItem> items;

  Module({
    required this.module,
    required this.items,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonItems = json['items'];
    List<PartItem> items = jsonItems.map((item) => PartItem.fromJson(item)).toList();

    return Module(
      module: json['module'],
      items: items,
    );
  }
}

class PartsList {
  final List<Module> modules;

  PartsList({
    required this.modules,
  });

  factory PartsList.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonModules = json['list'];
    List<Module> modules = jsonModules.map((module) => Module.fromJson(module)).toList();

    modules.add(Module.fromJson(json)); // Adding the top-level module

    return PartsList(
      modules: modules,
    );
  }
}
