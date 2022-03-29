import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../../infra/models/models.dart';

final regexpInts = RegExp(r'\d+');
final findAbsences = RegExp(r'gauge\d+.set\((\d+)');
final findAbsencesLimit = RegExp(r'gauge\d+.maxValue = \d+');

String trim(Element e) => e.text.trim();

Option<ProfileModel> extractProfile(Document homePage, Document profilePage) {
  final name = homePage.getElementsByClassName('avatar-principal-nome')[0].text;

  final cra = homePage.getElementsByClassName('text-purple')[0].text;
  final ch = homePage.getElementsByClassName('ch')[0].text;

  final items = profilePage
      .getElementsByClassName('form-control-static')
      .map(trim)
      .toList();

  if (items.isEmpty) {
    throw ParseError(
      'Erro com os dados recebidos do controle acadêmico!',
      null,
      null,
    );
  }

  final register = items[0];
  final programInfo = items[3];

  final program = programInfo.split('-').last.split('(').first.trim();

  final campus = (RegExp(r'\([^)]*\)').firstMatch(programInfo)?[0] ?? '')
      .replaceAll('(', '')
      .replaceAll(')', '');

  final profile = ProfileModel(
    register: register,
    name: name,
    program: program,
    campus: campus,
    cra: cra,
    cumulativeHours: ch,
  );

  return some(profile);
}
