import 'package:asp/asp.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

import '../../interactor/actions/courses_actions.dart';
import '../../interactor/actions/profile_actions.dart';
import '../../interactor/atoms/courses_atoms.dart';
import '../components/components.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> with HookStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final compact = size.width < 600;
    final medium = size.width >= 600 && size.width < 840;
    final expanded = size.width >= 840;

    final isLoading = useAtomState(coursesLoadingState);
    final courses = useAtomState(coursesState);

    Widget body;

    if (isLoading) {
      body = Center(child: CircularProgressIndicator.adaptive());
    } else if (courses.isEmpty) {
      body = const EmptyCollection(
        text: 'Sem Cursos Registrados',
        icon: Icons.library_books_rounded,
      );
    } else {
      body = RefreshIndicator(
        onRefresh: () async {
          refreshCourses();
          refreshProfile();
        },
        child: compact
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: courses.length,
                itemBuilder: (_, index) => CourseCard(
                  course: courses[index],
                ),
              )
            : DynamicHeightGridView(
                itemCount: courses.length,
                crossAxisCount: medium ? 2 : 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 16,
                builder: (_, index) => CourseCard(
                  course: courses[index],
                ),
              ),
      );
    }

    final semester = courses.firstOrNull?.semester ?? '';

    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        AppSliverAppbar(
          title: 'Cursos',
          subtitle: semester,
        )
      ],
      body: body,
    );
  }
}
