import 'package:password_manager/models/pm_icon.dart';

class IconUtil {
  static PMIcon getById(List<PMIcon> icons, String id) {
    return icons.firstWhere(
      (icon) => icon.id == id,
      orElse: () => defaultIcon,
    );
  }

  static PMIcon getByName(List<PMIcon> icons, String name) {
    return icons.firstWhere(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      orElse: () => defaultIcon,
    );
  }

  static PMIcon get defaultIcon {
    return PMIcon(
      id: '9b205201-f058-4457-a1cb-654d270f856ad',
      name: 'Default',
      url: 'assets/icons/default.png',
    );
  }
}
