import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/course/features/materials/domain/entities/picked_resource.dart';
import 'package:education_app/src/course/features/materials/presentation/widgets/picked_resource_detail.dart';
import 'package:flutter/material.dart';

class PickedResourceTile extends StatelessWidget {
  const PickedResourceTile(
    this.resource, {
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PickedResource resource;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image.asset(MediaRes.material),
            ),
            title: Text(
              resource.path.split('/').last,
              maxLines: 1,
            ),
            contentPadding: const EdgeInsets.only(left: 16, right: 5),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.close)),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          PickedResourceDetail(
            label: 'Author',
            value: resource.author,
          ),
          PickedResourceDetail(
            label: 'Title',
            value: resource.title,
          ),
          PickedResourceDetail(
            label: 'Description',
            value: resource.description.trim().isEmpty
                ? "'None'"
                : resource.description,
          ),
        ],
      ),
    );
  }
}
