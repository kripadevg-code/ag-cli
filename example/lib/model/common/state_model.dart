/// Generic state model for filters.
class StateModel {
  int id;
  String name;
  bool isSelected;

  StateModel({required this.id, required this.name, this.isSelected = false});
}
