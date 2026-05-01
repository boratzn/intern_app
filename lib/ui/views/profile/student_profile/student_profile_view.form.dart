// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String FirstNameValueKey = 'firstName';
const String LastNameValueKey = 'lastName';
const String UniversityValueKey = 'university';
const String DepartmentValueKey = 'department';
const String PhoneValueKey = 'phone';
const String LinkedinValueKey = 'linkedin';
const String GithubValueKey = 'github';
const String LocationValueKey = 'location';
const String BioValueKey = 'bio';
const String GradeYearValueKey = 'gradeYear';
const String GpaValueKey = 'gpa';
const String PortfolioValueKey = 'portfolio';
const String SkillsValueKey = 'skills';

final Map<String, TextEditingController>
_StudentProfileViewTextEditingControllers = {};

final Map<String, FocusNode> _StudentProfileViewFocusNodes = {};

final Map<String, String? Function(String?)?>
_StudentProfileViewTextValidations = {
  FirstNameValueKey: null,
  LastNameValueKey: null,
  UniversityValueKey: null,
  DepartmentValueKey: null,
  PhoneValueKey: null,
  LinkedinValueKey: null,
  GithubValueKey: null,
  LocationValueKey: null,
  BioValueKey: null,
  GradeYearValueKey: null,
  GpaValueKey: null,
  PortfolioValueKey: null,
  SkillsValueKey: null,
};

mixin $StudentProfileView {
  TextEditingController get firstNameController =>
      _getFormTextEditingController(FirstNameValueKey);
  TextEditingController get lastNameController =>
      _getFormTextEditingController(LastNameValueKey);
  TextEditingController get universityController =>
      _getFormTextEditingController(UniversityValueKey);
  TextEditingController get departmentController =>
      _getFormTextEditingController(DepartmentValueKey);
  TextEditingController get phoneController =>
      _getFormTextEditingController(PhoneValueKey);
  TextEditingController get linkedinController =>
      _getFormTextEditingController(LinkedinValueKey);
  TextEditingController get githubController =>
      _getFormTextEditingController(GithubValueKey);
  TextEditingController get locationController =>
      _getFormTextEditingController(LocationValueKey);
  TextEditingController get bioController =>
      _getFormTextEditingController(BioValueKey);
  TextEditingController get gradeYearController =>
      _getFormTextEditingController(GradeYearValueKey);
  TextEditingController get gpaController =>
      _getFormTextEditingController(GpaValueKey);
  TextEditingController get portfolioController =>
      _getFormTextEditingController(PortfolioValueKey);
  TextEditingController get skillsController =>
      _getFormTextEditingController(SkillsValueKey);

  FocusNode get firstNameFocusNode => _getFormFocusNode(FirstNameValueKey);
  FocusNode get lastNameFocusNode => _getFormFocusNode(LastNameValueKey);
  FocusNode get universityFocusNode => _getFormFocusNode(UniversityValueKey);
  FocusNode get departmentFocusNode => _getFormFocusNode(DepartmentValueKey);
  FocusNode get phoneFocusNode => _getFormFocusNode(PhoneValueKey);
  FocusNode get linkedinFocusNode => _getFormFocusNode(LinkedinValueKey);
  FocusNode get githubFocusNode => _getFormFocusNode(GithubValueKey);
  FocusNode get locationFocusNode => _getFormFocusNode(LocationValueKey);
  FocusNode get bioFocusNode => _getFormFocusNode(BioValueKey);
  FocusNode get gradeYearFocusNode => _getFormFocusNode(GradeYearValueKey);
  FocusNode get gpaFocusNode => _getFormFocusNode(GpaValueKey);
  FocusNode get portfolioFocusNode => _getFormFocusNode(PortfolioValueKey);
  FocusNode get skillsFocusNode => _getFormFocusNode(SkillsValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_StudentProfileViewTextEditingControllers.containsKey(key)) {
      return _StudentProfileViewTextEditingControllers[key]!;
    }

    _StudentProfileViewTextEditingControllers[key] = TextEditingController(
      text: initialValue,
    );
    return _StudentProfileViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_StudentProfileViewFocusNodes.containsKey(key)) {
      return _StudentProfileViewFocusNodes[key]!;
    }
    _StudentProfileViewFocusNodes[key] = FocusNode();
    return _StudentProfileViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    firstNameController.addListener(() => _updateFormData(model));
    lastNameController.addListener(() => _updateFormData(model));
    universityController.addListener(() => _updateFormData(model));
    departmentController.addListener(() => _updateFormData(model));
    phoneController.addListener(() => _updateFormData(model));
    linkedinController.addListener(() => _updateFormData(model));
    githubController.addListener(() => _updateFormData(model));
    locationController.addListener(() => _updateFormData(model));
    bioController.addListener(() => _updateFormData(model));
    gradeYearController.addListener(() => _updateFormData(model));
    gpaController.addListener(() => _updateFormData(model));
    portfolioController.addListener(() => _updateFormData(model));
    skillsController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    firstNameController.addListener(() => _updateFormData(model));
    lastNameController.addListener(() => _updateFormData(model));
    universityController.addListener(() => _updateFormData(model));
    departmentController.addListener(() => _updateFormData(model));
    phoneController.addListener(() => _updateFormData(model));
    linkedinController.addListener(() => _updateFormData(model));
    githubController.addListener(() => _updateFormData(model));
    locationController.addListener(() => _updateFormData(model));
    bioController.addListener(() => _updateFormData(model));
    gradeYearController.addListener(() => _updateFormData(model));
    gpaController.addListener(() => _updateFormData(model));
    portfolioController.addListener(() => _updateFormData(model));
    skillsController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap..addAll({
        FirstNameValueKey: firstNameController.text,
        LastNameValueKey: lastNameController.text,
        UniversityValueKey: universityController.text,
        DepartmentValueKey: departmentController.text,
        PhoneValueKey: phoneController.text,
        LinkedinValueKey: linkedinController.text,
        GithubValueKey: githubController.text,
        LocationValueKey: locationController.text,
        BioValueKey: bioController.text,
        GradeYearValueKey: gradeYearController.text,
        GpaValueKey: gpaController.text,
        PortfolioValueKey: portfolioController.text,
        SkillsValueKey: skillsController.text,
      }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _StudentProfileViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _StudentProfileViewFocusNodes.values) {
      focusNode.dispose();
    }

    _StudentProfileViewTextEditingControllers.clear();
    _StudentProfileViewFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this.fieldsValidationMessages.values.any(
    (validation) => validation != null,
  );

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get firstNameValue => this.formValueMap[FirstNameValueKey] as String?;
  String? get lastNameValue => this.formValueMap[LastNameValueKey] as String?;
  String? get universityValue =>
      this.formValueMap[UniversityValueKey] as String?;
  String? get departmentValue =>
      this.formValueMap[DepartmentValueKey] as String?;
  String? get phoneValue => this.formValueMap[PhoneValueKey] as String?;
  String? get linkedinValue => this.formValueMap[LinkedinValueKey] as String?;
  String? get githubValue => this.formValueMap[GithubValueKey] as String?;
  String? get locationValue => this.formValueMap[LocationValueKey] as String?;
  String? get bioValue => this.formValueMap[BioValueKey] as String?;
  String? get gradeYearValue => this.formValueMap[GradeYearValueKey] as String?;
  String? get gpaValue => this.formValueMap[GpaValueKey] as String?;
  String? get portfolioValue => this.formValueMap[PortfolioValueKey] as String?;
  String? get skillsValue => this.formValueMap[SkillsValueKey] as String?;

  set firstNameValue(String? value) {
    this.setData(this.formValueMap..addAll({FirstNameValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      FirstNameValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[FirstNameValueKey]?.text =
          value ?? '';
    }
  }

  set lastNameValue(String? value) {
    this.setData(this.formValueMap..addAll({LastNameValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      LastNameValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[LastNameValueKey]?.text =
          value ?? '';
    }
  }

  set universityValue(String? value) {
    this.setData(this.formValueMap..addAll({UniversityValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      UniversityValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[UniversityValueKey]?.text =
          value ?? '';
    }
  }

  set departmentValue(String? value) {
    this.setData(this.formValueMap..addAll({DepartmentValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      DepartmentValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[DepartmentValueKey]?.text =
          value ?? '';
    }
  }

  set phoneValue(String? value) {
    this.setData(this.formValueMap..addAll({PhoneValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(PhoneValueKey)) {
      _StudentProfileViewTextEditingControllers[PhoneValueKey]?.text =
          value ?? '';
    }
  }

  set linkedinValue(String? value) {
    this.setData(this.formValueMap..addAll({LinkedinValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      LinkedinValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[LinkedinValueKey]?.text =
          value ?? '';
    }
  }

  set githubValue(String? value) {
    this.setData(this.formValueMap..addAll({GithubValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(GithubValueKey)) {
      _StudentProfileViewTextEditingControllers[GithubValueKey]?.text =
          value ?? '';
    }
  }

  set locationValue(String? value) {
    this.setData(this.formValueMap..addAll({LocationValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      LocationValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[LocationValueKey]?.text =
          value ?? '';
    }
  }

  set bioValue(String? value) {
    this.setData(this.formValueMap..addAll({BioValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(BioValueKey)) {
      _StudentProfileViewTextEditingControllers[BioValueKey]?.text =
          value ?? '';
    }
  }

  set gradeYearValue(String? value) {
    this.setData(this.formValueMap..addAll({GradeYearValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      GradeYearValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[GradeYearValueKey]?.text =
          value ?? '';
    }
  }

  set gpaValue(String? value) {
    this.setData(this.formValueMap..addAll({GpaValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(GpaValueKey)) {
      _StudentProfileViewTextEditingControllers[GpaValueKey]?.text =
          value ?? '';
    }
  }

  set portfolioValue(String? value) {
    this.setData(this.formValueMap..addAll({PortfolioValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(
      PortfolioValueKey,
    )) {
      _StudentProfileViewTextEditingControllers[PortfolioValueKey]?.text =
          value ?? '';
    }
  }

  set skillsValue(String? value) {
    this.setData(this.formValueMap..addAll({SkillsValueKey: value}));

    if (_StudentProfileViewTextEditingControllers.containsKey(SkillsValueKey)) {
      _StudentProfileViewTextEditingControllers[SkillsValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasFirstName =>
      this.formValueMap.containsKey(FirstNameValueKey) &&
      (firstNameValue?.isNotEmpty ?? false);
  bool get hasLastName =>
      this.formValueMap.containsKey(LastNameValueKey) &&
      (lastNameValue?.isNotEmpty ?? false);
  bool get hasUniversity =>
      this.formValueMap.containsKey(UniversityValueKey) &&
      (universityValue?.isNotEmpty ?? false);
  bool get hasDepartment =>
      this.formValueMap.containsKey(DepartmentValueKey) &&
      (departmentValue?.isNotEmpty ?? false);
  bool get hasPhone =>
      this.formValueMap.containsKey(PhoneValueKey) &&
      (phoneValue?.isNotEmpty ?? false);
  bool get hasLinkedin =>
      this.formValueMap.containsKey(LinkedinValueKey) &&
      (linkedinValue?.isNotEmpty ?? false);
  bool get hasGithub =>
      this.formValueMap.containsKey(GithubValueKey) &&
      (githubValue?.isNotEmpty ?? false);
  bool get hasLocation =>
      this.formValueMap.containsKey(LocationValueKey) &&
      (locationValue?.isNotEmpty ?? false);
  bool get hasBio =>
      this.formValueMap.containsKey(BioValueKey) &&
      (bioValue?.isNotEmpty ?? false);
  bool get hasGradeYear =>
      this.formValueMap.containsKey(GradeYearValueKey) &&
      (gradeYearValue?.isNotEmpty ?? false);
  bool get hasGpa =>
      this.formValueMap.containsKey(GpaValueKey) &&
      (gpaValue?.isNotEmpty ?? false);
  bool get hasPortfolio =>
      this.formValueMap.containsKey(PortfolioValueKey) &&
      (portfolioValue?.isNotEmpty ?? false);
  bool get hasSkills =>
      this.formValueMap.containsKey(SkillsValueKey) &&
      (skillsValue?.isNotEmpty ?? false);

  bool get hasFirstNameValidationMessage =>
      this.fieldsValidationMessages[FirstNameValueKey]?.isNotEmpty ?? false;
  bool get hasLastNameValidationMessage =>
      this.fieldsValidationMessages[LastNameValueKey]?.isNotEmpty ?? false;
  bool get hasUniversityValidationMessage =>
      this.fieldsValidationMessages[UniversityValueKey]?.isNotEmpty ?? false;
  bool get hasDepartmentValidationMessage =>
      this.fieldsValidationMessages[DepartmentValueKey]?.isNotEmpty ?? false;
  bool get hasPhoneValidationMessage =>
      this.fieldsValidationMessages[PhoneValueKey]?.isNotEmpty ?? false;
  bool get hasLinkedinValidationMessage =>
      this.fieldsValidationMessages[LinkedinValueKey]?.isNotEmpty ?? false;
  bool get hasGithubValidationMessage =>
      this.fieldsValidationMessages[GithubValueKey]?.isNotEmpty ?? false;
  bool get hasLocationValidationMessage =>
      this.fieldsValidationMessages[LocationValueKey]?.isNotEmpty ?? false;
  bool get hasBioValidationMessage =>
      this.fieldsValidationMessages[BioValueKey]?.isNotEmpty ?? false;
  bool get hasGradeYearValidationMessage =>
      this.fieldsValidationMessages[GradeYearValueKey]?.isNotEmpty ?? false;
  bool get hasGpaValidationMessage =>
      this.fieldsValidationMessages[GpaValueKey]?.isNotEmpty ?? false;
  bool get hasPortfolioValidationMessage =>
      this.fieldsValidationMessages[PortfolioValueKey]?.isNotEmpty ?? false;
  bool get hasSkillsValidationMessage =>
      this.fieldsValidationMessages[SkillsValueKey]?.isNotEmpty ?? false;

  String? get firstNameValidationMessage =>
      this.fieldsValidationMessages[FirstNameValueKey];
  String? get lastNameValidationMessage =>
      this.fieldsValidationMessages[LastNameValueKey];
  String? get universityValidationMessage =>
      this.fieldsValidationMessages[UniversityValueKey];
  String? get departmentValidationMessage =>
      this.fieldsValidationMessages[DepartmentValueKey];
  String? get phoneValidationMessage =>
      this.fieldsValidationMessages[PhoneValueKey];
  String? get linkedinValidationMessage =>
      this.fieldsValidationMessages[LinkedinValueKey];
  String? get githubValidationMessage =>
      this.fieldsValidationMessages[GithubValueKey];
  String? get locationValidationMessage =>
      this.fieldsValidationMessages[LocationValueKey];
  String? get bioValidationMessage =>
      this.fieldsValidationMessages[BioValueKey];
  String? get gradeYearValidationMessage =>
      this.fieldsValidationMessages[GradeYearValueKey];
  String? get gpaValidationMessage =>
      this.fieldsValidationMessages[GpaValueKey];
  String? get portfolioValidationMessage =>
      this.fieldsValidationMessages[PortfolioValueKey];
  String? get skillsValidationMessage =>
      this.fieldsValidationMessages[SkillsValueKey];
}

extension Methods on FormStateHelper {
  void setFirstNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[FirstNameValueKey] = validationMessage;
  void setLastNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LastNameValueKey] = validationMessage;
  void setUniversityValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[UniversityValueKey] = validationMessage;
  void setDepartmentValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DepartmentValueKey] = validationMessage;
  void setPhoneValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PhoneValueKey] = validationMessage;
  void setLinkedinValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LinkedinValueKey] = validationMessage;
  void setGithubValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GithubValueKey] = validationMessage;
  void setLocationValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LocationValueKey] = validationMessage;
  void setBioValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BioValueKey] = validationMessage;
  void setGradeYearValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GradeYearValueKey] = validationMessage;
  void setGpaValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GpaValueKey] = validationMessage;
  void setPortfolioValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PortfolioValueKey] = validationMessage;
  void setSkillsValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[SkillsValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    firstNameValue = '';
    lastNameValue = '';
    universityValue = '';
    departmentValue = '';
    phoneValue = '';
    linkedinValue = '';
    githubValue = '';
    locationValue = '';
    bioValue = '';
    gradeYearValue = '';
    gpaValue = '';
    portfolioValue = '';
    skillsValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      FirstNameValueKey: getValidationMessage(FirstNameValueKey),
      LastNameValueKey: getValidationMessage(LastNameValueKey),
      UniversityValueKey: getValidationMessage(UniversityValueKey),
      DepartmentValueKey: getValidationMessage(DepartmentValueKey),
      PhoneValueKey: getValidationMessage(PhoneValueKey),
      LinkedinValueKey: getValidationMessage(LinkedinValueKey),
      GithubValueKey: getValidationMessage(GithubValueKey),
      LocationValueKey: getValidationMessage(LocationValueKey),
      BioValueKey: getValidationMessage(BioValueKey),
      GradeYearValueKey: getValidationMessage(GradeYearValueKey),
      GpaValueKey: getValidationMessage(GpaValueKey),
      PortfolioValueKey: getValidationMessage(PortfolioValueKey),
      SkillsValueKey: getValidationMessage(SkillsValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _StudentProfileViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _StudentProfileViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      FirstNameValueKey: getValidationMessage(FirstNameValueKey),
      LastNameValueKey: getValidationMessage(LastNameValueKey),
      UniversityValueKey: getValidationMessage(UniversityValueKey),
      DepartmentValueKey: getValidationMessage(DepartmentValueKey),
      PhoneValueKey: getValidationMessage(PhoneValueKey),
      LinkedinValueKey: getValidationMessage(LinkedinValueKey),
      GithubValueKey: getValidationMessage(GithubValueKey),
      LocationValueKey: getValidationMessage(LocationValueKey),
      BioValueKey: getValidationMessage(BioValueKey),
      GradeYearValueKey: getValidationMessage(GradeYearValueKey),
      GpaValueKey: getValidationMessage(GpaValueKey),
      PortfolioValueKey: getValidationMessage(PortfolioValueKey),
      SkillsValueKey: getValidationMessage(SkillsValueKey),
    });
