import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nozol_application/pages/building.dart';

class UpdateBuilding extends StatelessWidget {
  final Building building;

  UpdateBuilding({required this.building});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('${building.properties.type}'),
    );
  }
}