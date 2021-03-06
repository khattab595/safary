import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

@immutable
class SettingsState {}

class SettingsBloc extends Cubit<SettingsState> {
  SettingsBloc() : super(SettingsState());

  final GetStorage storage = GetStorage();
  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  late Locale _locale;
  Locale get locale => _locale;

  static SettingsBloc of(BuildContext context) {
    return BlocProvider.of<SettingsBloc>(context);
  }

  void loadSettings() {
    _themeMode = _readTheme();
    _locale = _readLocale();
    emit(SettingsState());
  }

  void updateThemeMode(ThemeMode? newThemeMode) {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    storage.write('themeMode', newThemeMode.toString());
    emit(SettingsState());
  }

  ThemeMode _readTheme() {
    if (storage.read('themeMode') == null) {
      return ThemeMode.system;
    }
    if (storage.read('themeMode') == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    }
    if (storage.read('themeMode') == ThemeMode.light.toString()) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  Locale _readLocale() {
    if (storage.read('locale') == null) {
      return const Locale('en');
    } else {
      return Locale(storage.read('locale'));
    }
  }

  void updateLocale(Locale? newLocale) {
    if (newLocale == null || newLocale == _locale) return;
    _locale = newLocale;
    emit(SettingsState());
    Get.updateLocale(newLocale);
    storage.write('locale', newLocale.languageCode);
  }
}
