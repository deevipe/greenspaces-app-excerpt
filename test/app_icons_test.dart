import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

void main() {
  test('app_icons assets test', () {
    expect(File(AppIcons.arrowLeft).existsSync(), true);
    expect(File(AppIcons.calendarIcon).existsSync(), true);
    expect(File(AppIcons.cameraIcon).existsSync(), true);
    expect(File(AppIcons.checkedBox).existsSync(), true);
    expect(File(AppIcons.chevronDown).existsSync(), true);
    expect(File(AppIcons.chevronUp).existsSync(), true);
    expect(File(AppIcons.compasIcon).existsSync(), true);
    expect(File(AppIcons.copyIcon).existsSync(), true);
    expect(File(AppIcons.deleteIcon).existsSync(), true);
    expect(File(AppIcons.docIcon).existsSync(), true);
    expect(File(AppIcons.doneIcon).existsSync(), true);
    expect(File(AppIcons.exclamationCircle).existsSync(), true);
    expect(File(AppIcons.filledPin).existsSync(), true);
    expect(File(AppIcons.flowerIcon).existsSync(), true);
    expect(File(AppIcons.homeIcon).existsSync(), true);
    expect(File(AppIcons.improveProjectIcon).existsSync(), true);
    expect(File(AppIcons.logoutIcon).existsSync(), true);
    expect(File(AppIcons.mapIcon).existsSync(), true);
    expect(File(AppIcons.minusIcon).existsSync(), true);
    expect(File(AppIcons.pdfIcon).existsSync(), true);
    expect(File(AppIcons.plusIcon).existsSync(), true);
    expect(File(AppIcons.projectIcon).existsSync(), true);
    expect(File(AppIcons.txtIcon).existsSync(), true);
    expect(File(AppIcons.uncheckedBox).existsSync(), true);
    expect(File(AppIcons.visibilityOff).existsSync(), true);
    expect(File(AppIcons.visibilityOn).existsSync(), true);
  });
}
