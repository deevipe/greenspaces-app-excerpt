import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

void main() {
  test('app_images assets test', () {
    expect(File(AppImages.authBg).existsSync(), true);
    expect(File(AppImages.noBlurPng).existsSync(), true);
    expect(File(AppImages.noImage).existsSync(), true);
  });
}
