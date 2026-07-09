import 'package:ag_cli/ag_cli.dart';
import 'package:test/test.dart';

void main() {
  group('toSnake', () {
    test('converts PascalCase',
        () => expect(toSnake('ProblemModule'), 'problem_module'));
    test(
        'converts camelCase', () => expect(toSnake('myFeature'), 'my_feature'));
    test('lowercases plain word',
        () => expect(toSnake('incidents'), 'incidents'));
    test('handles dashes and spaces',
        () => expect(toSnake('my-feature name'), 'my_feature_name'));
  });

  group('toPascal', () {
    test('converts snake_case',
        () => expect(toPascal('problem_module'), 'ProblemModule'));
    test('converts single word',
        () => expect(toPascal('incidents'), 'Incidents'));
    test('converts space-separated',
        () => expect(toPascal('my feature'), 'MyFeature'));
  });

  group('toCamel', () {
    test('converts snake_case',
        () => expect(toCamel('problem_module'), 'problemModule'));
    test(
        'converts PascalCase', () => expect(toCamel('Incidents'), 'incidents'));
    test('converts single word', () => expect(toCamel('test'), 'test'));
  });

  group('resolveGeneratorName', () {
    test('resolves full names', () {
      expect(resolveGeneratorName('module'), 'module');
      expect(resolveGeneratorName('component'), 'component');
      expect(resolveGeneratorName('model'), 'model');
      expect(resolveGeneratorName('repo'), 'repo');
      expect(resolveGeneratorName('controller'), 'controller');
      expect(resolveGeneratorName('binding'), 'binding');
      expect(resolveGeneratorName('page'), 'page');
    });

    test('resolves shortcuts', () {
      expect(resolveGeneratorName('m'), 'module');
      expect(resolveGeneratorName('c'), 'component');
      expect(resolveGeneratorName('r'), 'repo');
      expect(resolveGeneratorName('ctrl'), 'controller');
      expect(resolveGeneratorName('b'), 'binding');
      expect(resolveGeneratorName('p'), 'page');
    });

    test('resolves aliases', () {
      expect(resolveGeneratorName('repository'), 'repo');
    });

    test('returns null for unknown', () {
      expect(resolveGeneratorName('unknown'), isNull);
      expect(resolveGeneratorName(''), isNull);
    });

    test('is case-insensitive', () {
      expect(resolveGeneratorName('Module'), 'module');
      expect(resolveGeneratorName('COMPONENT'), 'component');
    });
  });

  group('cliVersion', () {
    test('is not empty', () => expect(cliVersion.isNotEmpty, isTrue));
    test('follows semver', () {
      expect(RegExp(r'^\d+\.\d+\.\d+$').hasMatch(cliVersion), isTrue);
    });
  });
}
