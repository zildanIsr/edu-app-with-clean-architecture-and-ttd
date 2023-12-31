part of 'material_cubit.dart';

sealed class MaterialState extends Equatable {
  const MaterialState();

  @override
  List<Object> get props => [];
}

final class MaterialInitial extends MaterialState {}

class MaterialAdded extends MaterialState {
  const MaterialAdded();
}

class AddingMaterial extends MaterialState {
  const AddingMaterial();
}

class LoadingMaterials extends MaterialState {
  const LoadingMaterials();
}

class MaterialsLoaded extends MaterialState {
  const MaterialsLoaded(this.materials);

  final List<Resource> materials;

  @override
  List<Object> get props => [materials];
}

class MaterialError extends MaterialState {
  const MaterialError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
