import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../../../shared/data/extensions/extensions.dart';
import '../../../../shared/ui/widgets/empty_collection.dart';
import '../../../auth/atoms/auth_atom.dart';
import '../../../profile/atoms/profile_atom.dart';
import '../atoms/courses_atom.dart';
import '../components/course_info_card.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState.value != null) {
        fetchCourses();
      }
      coursesResultState
        ..removeListener(resultListener)
        ..addListener(resultListener);
    });

    super.initState();
  }

  void resultListener() {
    final result = coursesResultState.value;
    if (result == null) return;

    void resetResult() {
      coursesResultState.value = null;
    }

    result.fold(
      (success) => context.showMessage(success, resetResult),
      (error) {
        if (error.code == 'anti_span') {
          context.showErrorWithAction(
            error.message,
            onClosed: resetResult,
            label: 'Entrar',
            onPressed: resetAuthAction,
          );
        } else {
          context.showError(error.message, resetResult);
        }
      },
    );
  }

  void resetResult() {
    coursesResultState.value = null;
  }

  @override
  void dispose() {
    coursesResultState.removeListener(resultListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (isLoading, courses, _) = context.select(
      () => (
        coursesLoadingState.value,
        coursesState.value,
        coursesState.value.length,
      ),
    );

    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (courses.isEmpty) {
      return const EmptyCollection(
        text: 'Sem Cursos Registrados',
        icon: Icons.library_books_rounded,
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          refreshCourses();
          refreshProfile();
        },
        child: ListView.separated(
          itemCount: courses.length,
          padding: const EdgeInsets.symmetric(
            vertical: 24,
          ),
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            child: CourseInfoCard(course: courses[index]),
          ),
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.all(24),
            child: Divider(),
          ),
        ),
      );
    }
  }
}
