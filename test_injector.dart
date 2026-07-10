import 'dart:io';

void main() {
  String content = File('example/lib/routes/app_pages.dart').readAsStringSync();
  int idx = content.lastIndexOf('];');
  print('idx: $idx');
  if (idx != -1) {
    content = content.replaceRange(idx, idx, 'TEST_INJECT\n  ');
    print(content);
  }
}
