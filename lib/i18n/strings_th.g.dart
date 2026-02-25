///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsTh with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTh({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.th,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <th>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsTh _root = this; // ignore: unused_field

	@override 
	TranslationsTh $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTh(meta: meta ?? this.$meta);

	// Translations
	@override String hello({required Object name}) => 'สวัสดี ${name}';
	@override String get save => 'บันทึก';
	@override late final _TranslationsLoginTh login = _TranslationsLoginTh._(_root);
	@override late final _TranslationsCommonTh common = _TranslationsCommonTh._(_root);
}

// Path: login
class _TranslationsLoginTh implements TranslationsLoginEn {
	_TranslationsLoginTh._(this._root);

	final TranslationsTh _root; // ignore: unused_field

	// Translations
	@override String get username => 'ชื่อผู้ใช้';
	@override String get password => 'รหัสผ่าน';
	@override String get login_button => 'เข้าสู่ระบบ';
	@override String get success => 'เข้าสู่ระบบสำเร็จ';
	@override String get fail => 'เข้าสู่ระบบไม่สำเร็จ';
	@override String get password_min_length => 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
}

// Path: common
class _TranslationsCommonTh implements TranslationsCommonEn {
	_TranslationsCommonTh._(this._root);

	final TranslationsTh _root; // ignore: unused_field

	// Translations
	@override String required_field({required Object field}) => 'จำเป็นต้องกรอก ${field}';
}

/// The flat map containing all translations for locale <th>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTh {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'hello' => ({required Object name}) => 'สวัสดี ${name}',
			'save' => 'บันทึก',
			'login.username' => 'ชื่อผู้ใช้',
			'login.password' => 'รหัสผ่าน',
			'login.login_button' => 'เข้าสู่ระบบ',
			'login.success' => 'เข้าสู่ระบบสำเร็จ',
			'login.fail' => 'เข้าสู่ระบบไม่สำเร็จ',
			'login.password_min_length' => 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร',
			'common.required_field' => ({required Object field}) => 'จำเป็นต้องกรอก ${field}',
			_ => null,
		};
	}
}
