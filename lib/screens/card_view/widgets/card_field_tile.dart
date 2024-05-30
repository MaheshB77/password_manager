import 'package:flutter/material.dart';

class CardFieldTile extends StatelessWidget {
  final String heading;
  final String value;

  const CardFieldTile({
    super.key,
    required this.heading,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      minVerticalPadding: 4,
      title: Text(
        heading,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(fontWeight: FontWeight.w300),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      onTap: () {},
    );
  }
}
