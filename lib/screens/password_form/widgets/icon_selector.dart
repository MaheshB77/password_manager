import 'package:flutter/material.dart';
import 'package:password_manager/constants/icons.dart';
import 'package:password_manager/models/pm_icon.dart';
import 'package:password_manager/shared/utils/icon_util.dart';

class IconSelector extends StatefulWidget {
  final void Function(PMIcon selectedIcon) onSelectedIcon;
  const IconSelector({
    super.key,
    required this.onSelectedIcon,
  });

  @override
  State<StatefulWidget> createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  String? _selectedIcon;

  List<Widget> get icons {
    return pmIcons
        .map(
          (icon) => Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
              color: _selectedIcon == icon.id
                  ? Colors.deepPurple[200]
                  : Colors.transparent,
            ),
            child: IconButton(
              onPressed: () {
                setState(() => _selectedIcon = icon.id);
                widget.onSelectedIcon(IconUtil.getById(pmIcons, icon.id));
              },
              icon: Image.asset(icon.url, width: 30),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    print('Rendering Icon selector!!');
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                padding: const EdgeInsets.all(12),
                mainAxisSpacing: 12,
                crossAxisSpacing: 18,
                children: icons,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline_outlined,
                    size: 50,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
