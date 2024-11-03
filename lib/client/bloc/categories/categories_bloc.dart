import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetman/server/repository/categories/categories_repository.dart';

// Events
abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoriesEvent {}

class AddCategory extends CategoriesEvent {
  final Category category;

  const AddCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends CategoriesEvent {
  final Category category;

  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class RemoveCategory extends CategoriesEvent {
  final Category category;

  const RemoveCategory(this.category);

  @override
  List<Object?> get props => [category];
}

// States
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository _categoryRepository;

  CategoriesBloc(this._categoryRepository) : super(CategoriesLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<RemoveCategory>(_onRemoveCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoriesState> emit) async {
    emit(CategoriesLoading());
    try {
      final categories = await _categoryRepository.getAll();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(const CategoriesError("ไม่สามารถโหลดหมวดหมู่ได้ กรุณาลองใหม่อีกครั้ง."));
    }
  }

  Future<void> _onAddCategory(
      AddCategory event, Emitter<CategoriesState> emit) async {
    if (state is CategoriesLoaded) {
      try {
        await _categoryRepository.add(event.category); // เรียกใช้ repository เพื่อเพิ่มหมวดหมู่
        final List<Category> updatedCategories =
            List.from((state as CategoriesLoaded).categories)..add(event.category);
        emit(CategoriesLoaded(updatedCategories));
      } catch (e) {
        emit(const CategoriesError("ไม่สามารถเพิ่มหมวดหมู่ได้ กรุณาลองใหม่อีกครั้ง."));
      }
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event, Emitter<CategoriesState> emit) async {
  if (state is CategoriesLoaded) {
    try {
      print('Attempting to update category with id: ${event.category.id}');
      await _categoryRepository.update(event.category); // เรียกใช้ repository เพื่ออัพเดตหมวดหมู่
      final List<Category> updatedCategories = (state as CategoriesLoaded)
          .categories
          .map((category) => category.id == event.category.id ? event.category : category)
          .toList();
      emit(CategoriesLoaded(updatedCategories));
    } catch (e) {
      print('Error updating category: $e');
      emit(const CategoriesError("ไม่สามารถอัพเดตหมวดหมู่ได้ กรุณาลองใหม่อีกครั้ง."));
    }
  }
}



  Future<void> _onRemoveCategory(
      RemoveCategory event, Emitter<CategoriesState> emit) async {
    if (state is CategoriesLoaded) {
      try {
        await _categoryRepository.delete(event.category.id); // เรียกใช้ repository เพื่อลบหมวดหมู่โดยใช้ id
        final List<Category> updatedCategories = (state as CategoriesLoaded)
            .categories
            .where((category) => category.id != event.category.id)
            .toList();
        emit(CategoriesLoaded(updatedCategories));
      } catch (e) {
        emit(const CategoriesError("ไม่สามารถลบหมวดหมู่ได้ กรุณาลองใหม่อีกครั้ง."));
      }
    }
  }
}
bool isCategoryNameUnique(CategoriesState state, String name) {
  if (state is CategoriesLoaded) {
    final existingCategories = (state as CategoriesLoaded).categories;
    return !existingCategories.any((category) => category.name == name);
  }
  return true;
}