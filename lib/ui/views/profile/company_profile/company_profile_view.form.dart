// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String CompanyNameValueKey = 'companyName';
const String IndustryValueKey = 'industry';
const String WebsiteValueKey = 'website';
const String ContactPersonValueKey = 'contactPerson';
const String AboutValueKey = 'about';
const String EmployeeCountValueKey = 'employeeCount';
const String LinkedinUrlValueKey = 'linkedinUrl';
const String CityValueKey = 'city';
const String EmailValueKey = 'email';

final Map<String, TextEditingController>
_CompanyProfileViewTextEditingControllers = {};

final Map<String, FocusNode> _CompanyProfileViewFocusNodes = {};

final Map<String, String? Function(String?)?>
_CompanyProfileViewTextValidations = {
  CompanyNameValueKey: null,
  IndustryValueKey: null,
  WebsiteValueKey: null,
  ContactPersonValueKey: null,
  AboutValueKey: null,
  EmployeeCountValueKey: null,
  LinkedinUrlValueKey: null,
  CityValueKey: null,
  EmailValueKey: null,
};

mixin $CompanyProfileView {
  TextEditingController get companyNameController =>
      _getFormTextEditingController(CompanyNameValueKey);
  TextEditingController get industryController =>
      _getFormTextEditingController(IndustryValueKey);
  TextEditingController get websiteController =>
      _getFormTextEditingController(WebsiteValueKey);
  TextEditingController get contactPersonController =>
      _getFormTextEditingController(ContactPersonValueKey);
  TextEditingController get aboutController =>
      _getFormTextEditingController(AboutValueKey);
  TextEditingController get employeeCountController =>
      _getFormTextEditingController(EmployeeCountValueKey);
  TextEditingController get linkedinUrlController =>
      _getFormTextEditingController(LinkedinUrlValueKey);
  TextEditingController get cityController =>
      _getFormTextEditingController(CityValueKey);
  TextEditingController get emailController =>
      _getFormTextEditingController(EmailValueKey);

  FocusNode get companyNameFocusNode => _getFormFocusNode(CompanyNameValueKey);
  FocusNode get industryFocusNode => _getFormFocusNode(IndustryValueKey);
  FocusNode get websiteFocusNode => _getFormFocusNode(WebsiteValueKey);
  FocusNode get contactPersonFocusNode =>
      _getFormFocusNode(ContactPersonValueKey);
  FocusNode get aboutFocusNode => _getFormFocusNode(AboutValueKey);
  FocusNode get employeeCountFocusNode =>
      _getFormFocusNode(EmployeeCountValueKey);
  FocusNode get linkedinUrlFocusNode => _getFormFocusNode(LinkedinUrlValueKey);
  FocusNode get cityFocusNode => _getFormFocusNode(CityValueKey);
  FocusNode get emailFocusNode => _getFormFocusNode(EmailValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_CompanyProfileViewTextEditingControllers.containsKey(key)) {
      return _CompanyProfileViewTextEditingControllers[key]!;
    }

    _CompanyProfileViewTextEditingControllers[key] = TextEditingController(
      text: initialValue,
    );
    return _CompanyProfileViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_CompanyProfileViewFocusNodes.containsKey(key)) {
      return _CompanyProfileViewFocusNodes[key]!;
    }
    _CompanyProfileViewFocusNodes[key] = FocusNode();
    return _CompanyProfileViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    companyNameController.addListener(() => _updateFormData(model));
    industryController.addListener(() => _updateFormData(model));
    websiteController.addListener(() => _updateFormData(model));
    contactPersonController.addListener(() => _updateFormData(model));
    aboutController.addListener(() => _updateFormData(model));
    employeeCountController.addListener(() => _updateFormData(model));
    linkedinUrlController.addListener(() => _updateFormData(model));
    cityController.addListener(() => _updateFormData(model));
    emailController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    companyNameController.addListener(() => _updateFormData(model));
    industryController.addListener(() => _updateFormData(model));
    websiteController.addListener(() => _updateFormData(model));
    contactPersonController.addListener(() => _updateFormData(model));
    aboutController.addListener(() => _updateFormData(model));
    employeeCountController.addListener(() => _updateFormData(model));
    linkedinUrlController.addListener(() => _updateFormData(model));
    cityController.addListener(() => _updateFormData(model));
    emailController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap..addAll({
        CompanyNameValueKey: companyNameController.text,
        IndustryValueKey: industryController.text,
        WebsiteValueKey: websiteController.text,
        ContactPersonValueKey: contactPersonController.text,
        AboutValueKey: aboutController.text,
        EmployeeCountValueKey: employeeCountController.text,
        LinkedinUrlValueKey: linkedinUrlController.text,
        CityValueKey: cityController.text,
        EmailValueKey: emailController.text,
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

    for (var controller in _CompanyProfileViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _CompanyProfileViewFocusNodes.values) {
      focusNode.dispose();
    }

    _CompanyProfileViewTextEditingControllers.clear();
    _CompanyProfileViewFocusNodes.clear();
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

  String? get companyNameValue =>
      this.formValueMap[CompanyNameValueKey] as String?;
  String? get industryValue => this.formValueMap[IndustryValueKey] as String?;
  String? get websiteValue => this.formValueMap[WebsiteValueKey] as String?;
  String? get contactPersonValue =>
      this.formValueMap[ContactPersonValueKey] as String?;
  String? get aboutValue => this.formValueMap[AboutValueKey] as String?;
  String? get employeeCountValue =>
      this.formValueMap[EmployeeCountValueKey] as String?;
  String? get linkedinUrlValue =>
      this.formValueMap[LinkedinUrlValueKey] as String?;
  String? get cityValue => this.formValueMap[CityValueKey] as String?;
  String? get emailValue => this.formValueMap[EmailValueKey] as String?;

  set companyNameValue(String? value) {
    this.setData(this.formValueMap..addAll({CompanyNameValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(
      CompanyNameValueKey,
    )) {
      _CompanyProfileViewTextEditingControllers[CompanyNameValueKey]?.text =
          value ?? '';
    }
  }

  set industryValue(String? value) {
    this.setData(this.formValueMap..addAll({IndustryValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(
      IndustryValueKey,
    )) {
      _CompanyProfileViewTextEditingControllers[IndustryValueKey]?.text =
          value ?? '';
    }
  }

  set websiteValue(String? value) {
    this.setData(this.formValueMap..addAll({WebsiteValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(
      WebsiteValueKey,
    )) {
      _CompanyProfileViewTextEditingControllers[WebsiteValueKey]?.text =
          value ?? '';
    }
  }

  set contactPersonValue(String? value) {
    this.setData(this.formValueMap..addAll({ContactPersonValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(
      ContactPersonValueKey,
    )) {
      _CompanyProfileViewTextEditingControllers[ContactPersonValueKey]?.text =
          value ?? '';
    }
  }

  set aboutValue(String? value) {
    this.setData(this.formValueMap..addAll({AboutValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(AboutValueKey)) {
      _CompanyProfileViewTextEditingControllers[AboutValueKey]?.text =
          value ?? '';
    }
  }

  set employeeCountValue(String? value) {
    this.setData(this.formValueMap..addAll({EmployeeCountValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(
      EmployeeCountValueKey,
    )) {
      _CompanyProfileViewTextEditingControllers[EmployeeCountValueKey]?.text =
          value ?? '';
    }
  }

  set linkedinUrlValue(String? value) {
    this.setData(this.formValueMap..addAll({LinkedinUrlValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(
      LinkedinUrlValueKey,
    )) {
      _CompanyProfileViewTextEditingControllers[LinkedinUrlValueKey]?.text =
          value ?? '';
    }
  }

  set cityValue(String? value) {
    this.setData(this.formValueMap..addAll({CityValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(CityValueKey)) {
      _CompanyProfileViewTextEditingControllers[CityValueKey]?.text =
          value ?? '';
    }
  }

  set emailValue(String? value) {
    this.setData(this.formValueMap..addAll({EmailValueKey: value}));

    if (_CompanyProfileViewTextEditingControllers.containsKey(EmailValueKey)) {
      _CompanyProfileViewTextEditingControllers[EmailValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasCompanyName =>
      this.formValueMap.containsKey(CompanyNameValueKey) &&
      (companyNameValue?.isNotEmpty ?? false);
  bool get hasIndustry =>
      this.formValueMap.containsKey(IndustryValueKey) &&
      (industryValue?.isNotEmpty ?? false);
  bool get hasWebsite =>
      this.formValueMap.containsKey(WebsiteValueKey) &&
      (websiteValue?.isNotEmpty ?? false);
  bool get hasContactPerson =>
      this.formValueMap.containsKey(ContactPersonValueKey) &&
      (contactPersonValue?.isNotEmpty ?? false);
  bool get hasAbout =>
      this.formValueMap.containsKey(AboutValueKey) &&
      (aboutValue?.isNotEmpty ?? false);
  bool get hasEmployeeCount =>
      this.formValueMap.containsKey(EmployeeCountValueKey) &&
      (employeeCountValue?.isNotEmpty ?? false);
  bool get hasLinkedinUrl =>
      this.formValueMap.containsKey(LinkedinUrlValueKey) &&
      (linkedinUrlValue?.isNotEmpty ?? false);
  bool get hasCity =>
      this.formValueMap.containsKey(CityValueKey) &&
      (cityValue?.isNotEmpty ?? false);
  bool get hasEmail =>
      this.formValueMap.containsKey(EmailValueKey) &&
      (emailValue?.isNotEmpty ?? false);

  bool get hasCompanyNameValidationMessage =>
      this.fieldsValidationMessages[CompanyNameValueKey]?.isNotEmpty ?? false;
  bool get hasIndustryValidationMessage =>
      this.fieldsValidationMessages[IndustryValueKey]?.isNotEmpty ?? false;
  bool get hasWebsiteValidationMessage =>
      this.fieldsValidationMessages[WebsiteValueKey]?.isNotEmpty ?? false;
  bool get hasContactPersonValidationMessage =>
      this.fieldsValidationMessages[ContactPersonValueKey]?.isNotEmpty ?? false;
  bool get hasAboutValidationMessage =>
      this.fieldsValidationMessages[AboutValueKey]?.isNotEmpty ?? false;
  bool get hasEmployeeCountValidationMessage =>
      this.fieldsValidationMessages[EmployeeCountValueKey]?.isNotEmpty ?? false;
  bool get hasLinkedinUrlValidationMessage =>
      this.fieldsValidationMessages[LinkedinUrlValueKey]?.isNotEmpty ?? false;
  bool get hasCityValidationMessage =>
      this.fieldsValidationMessages[CityValueKey]?.isNotEmpty ?? false;
  bool get hasEmailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey]?.isNotEmpty ?? false;

  String? get companyNameValidationMessage =>
      this.fieldsValidationMessages[CompanyNameValueKey];
  String? get industryValidationMessage =>
      this.fieldsValidationMessages[IndustryValueKey];
  String? get websiteValidationMessage =>
      this.fieldsValidationMessages[WebsiteValueKey];
  String? get contactPersonValidationMessage =>
      this.fieldsValidationMessages[ContactPersonValueKey];
  String? get aboutValidationMessage =>
      this.fieldsValidationMessages[AboutValueKey];
  String? get employeeCountValidationMessage =>
      this.fieldsValidationMessages[EmployeeCountValueKey];
  String? get linkedinUrlValidationMessage =>
      this.fieldsValidationMessages[LinkedinUrlValueKey];
  String? get cityValidationMessage =>
      this.fieldsValidationMessages[CityValueKey];
  String? get emailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey];
}

extension Methods on FormStateHelper {
  void setCompanyNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CompanyNameValueKey] = validationMessage;
  void setIndustryValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[IndustryValueKey] = validationMessage;
  void setWebsiteValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[WebsiteValueKey] = validationMessage;
  void setContactPersonValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ContactPersonValueKey] = validationMessage;
  void setAboutValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AboutValueKey] = validationMessage;
  void setEmployeeCountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[EmployeeCountValueKey] = validationMessage;
  void setLinkedinUrlValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LinkedinUrlValueKey] = validationMessage;
  void setCityValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CityValueKey] = validationMessage;
  void setEmailValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[EmailValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    companyNameValue = '';
    industryValue = '';
    websiteValue = '';
    contactPersonValue = '';
    aboutValue = '';
    employeeCountValue = '';
    linkedinUrlValue = '';
    cityValue = '';
    emailValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      CompanyNameValueKey: getValidationMessage(CompanyNameValueKey),
      IndustryValueKey: getValidationMessage(IndustryValueKey),
      WebsiteValueKey: getValidationMessage(WebsiteValueKey),
      ContactPersonValueKey: getValidationMessage(ContactPersonValueKey),
      AboutValueKey: getValidationMessage(AboutValueKey),
      EmployeeCountValueKey: getValidationMessage(EmployeeCountValueKey),
      LinkedinUrlValueKey: getValidationMessage(LinkedinUrlValueKey),
      CityValueKey: getValidationMessage(CityValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _CompanyProfileViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _CompanyProfileViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      CompanyNameValueKey: getValidationMessage(CompanyNameValueKey),
      IndustryValueKey: getValidationMessage(IndustryValueKey),
      WebsiteValueKey: getValidationMessage(WebsiteValueKey),
      ContactPersonValueKey: getValidationMessage(ContactPersonValueKey),
      AboutValueKey: getValidationMessage(AboutValueKey),
      EmployeeCountValueKey: getValidationMessage(EmployeeCountValueKey),
      LinkedinUrlValueKey: getValidationMessage(LinkedinUrlValueKey),
      CityValueKey: getValidationMessage(CityValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
    });
