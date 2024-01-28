import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:education_app/src/course/features/materials/presentation/app/provider/resource_controller.dart';
import 'package:education_app/src/course/features/materials/presentation/widgets/resource_tile.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class CourseMaterialView extends StatefulWidget {
  const CourseMaterialView(this.course, {super.key});

  final Course course;

  static const routeName = '/course-materials';

  @override
  State<CourseMaterialView> createState() => _CourseMaterialViewState();
}

class _CourseMaterialViewState extends State<CourseMaterialView> {
  void getMaterials() {
    context.read<MaterialCubit>().getMaterial(widget.course.id);
  }

  @override
  void initState() {
    getMaterials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.course.title} Materials'),
        leading: const NestedBackButton(),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: BlocConsumer<MaterialCubit, MaterialState>(
            listener: (_, state) {
              if (state is MaterialError) {
                CoreUtils.showSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is LoadingMaterials) {
                return const LoadingView();
              } else if ((state is MaterialsLoaded &&
                      state.materials.isEmpty) ||
                  state is MaterialError) {
                return NotFoundText(
                  text: 'No material found for ${widget.course.title}',
                );
              } else if (state is MaterialsLoaded) {
                final materials = state.materials;
                return AnimationLimiter(
                  child: ListView.separated(
                    separatorBuilder: (_, __) => const Divider(
                      color: Color(0xFFE6E8EC),
                    ),
                    padding: const EdgeInsets.all(20),
                    itemCount: state.materials.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: ChangeNotifierProvider(
                              create: (_) => sl<ResourceController>()
                                ..init(materials[index]),
                              child: const ResourceTile(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
