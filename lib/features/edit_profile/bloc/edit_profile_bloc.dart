import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie/core/bloc/page_command.dart';
import 'package:movie/core/common/enums/gender.dart';
import 'package:movie/core/common/enums/sheet_type.dart';
import 'package:movie/core/data/model/country_model.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';
part 'edit_profile_bloc.freezed.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(const EditProfileState()) {
    on<_OnChangeFullName>((event, emit) {
      emit(state.copyWith(fullName: event.text, enable: isSaved, page: null));
    });

    on<_OnChangeEmail>((event, emit) {
      emit(state.copyWith(email: event.text, enable: isSaved, page: null));
    });

    on<_OnChangePhoneNumber>((event, emit) {
      emit(
          state.copyWith(phoneNumber: event.text, enable: isSaved, page: null));
    });

    on<_OnLoadGender>((event, emit) {
      emit(state.copyWith(
        page: PageCommandShowBottomSheet(sheetType: SheetType.getListGender),
      ));
    });

    on<_OnLoadCountry>((event, emit) async {
      List<CountryModel> countries = await getCountries();
      emit(state.copyWith(
        page: PageCommandShowBottomSheet(sheetType: SheetType.country),
        countries: countries,
      ));
    });

    on<_OnLoadCountryCode>((event, emit) async {
      List<CountryModel> countries = await getCountries();
      emit(state.copyWith(
          page: PageCommandShowBottomSheet(sheetType: SheetType.countryCode),
          listCountryCode: countries));
    });

    on<_OnChangeGender>((event, emit) {
      emit(state.copyWith(selectedGender: event.gender, page: null));
    });

    on<_OnChangeCountry>((event, emit) {
      emit(state.copyWith(selectedCountry: event.item, page: null));
    });

    on<_OnSelectedGender>((event, emit) {
      emit(state.copyWith(gender: event.genderName));
    });

    on<_OnSelectedCountry>((event, emit) {
      emit(state.copyWith(country: state.selectedCountry!.name));
    });

    on<_OnChangeCountryCode>((event, emit) {
      emit(state.copyWith(selectedCountryCode: event.item, page: null));
    });

    on<_OnSelectedCountryCode>((event, emit) {
      emit(state.copyWith(flag: state.selectedCountryCode!.flag));
    });

    on<_OnUpdate>((event, emit) {});
  }

  Future<void> emitCountry(
      Emitter<EditProfileState> emit, SheetType type) async {
    if (state.countries.isNotEmpty) {
      emit(state.copyWith(
        page: PageCommandShowBottomSheet(sheetType: type),
        countries: state.countries,
      ));
    }

    List<CountryModel> countries = await getCountries();

    emit(state.copyWith(
      page: PageCommandShowBottomSheet(sheetType: type),
      countries: countries,
    ));
  }

  Future<List<CountryModel>> getCountries() async {
    String data = await rootBundle.loadString("assets/country/countries.json");
    final json = jsonDecode(data)["countries"] as List;
    List<CountryModel> countries =
        json.map((item) => CountryModel.fromJson(item)).toList();
    return countries;
  }

  bool get isSaved {
    return state.fullName != null && state.phoneNumber != null;
  }
}
