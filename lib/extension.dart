import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  T getBloc<T extends StateStreamableSource<Object?>>({bool listen = false}) => BlocProvider.of<T>(this, listen: listen);
  T getRepo<T extends Object>({bool listen = false}) => RepositoryProvider.of<T>(this, listen: listen);
}