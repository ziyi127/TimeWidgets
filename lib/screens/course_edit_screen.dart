import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import '../models/timetable_edit_model.dart';
import '../services/timetable_edit_service.dart';

class CourseEditScreen extends StatefulWidget {
  const CourseEditScreen({super.key});

  @override
  State<CourseEditScreen> createState() => _CourseEditScreenState();
}

class _CourseEditScreenState extends State<CourseEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _classroomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    _classroomController.dispose();
    super.dispose();
  }

  void _showAddCourseDialog() {
    _nameController.clear();
    _teacherController.clear();
    _classroomController.clear();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加课程'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '课程名称',
                  hintText: '请输入课程名称',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入课程名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(
                  labelText: '授课教师',
                  hintText: '请输入教师姓名',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _classroomController,
                decoration: const InputDecoration(
                  labelText: '教室',
                  hintText: '请输入教室位置',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final course = CourseInfo(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  teacher: _teacherController.text,
                  classroom: _classroomController.text,
                );

                Provider.of<TimetableEditService>(context, listen: false)
                    .addCourse(course);

                Navigator.of(context).pop();
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showEditCourseDialog(CourseInfo course) {
    _nameController.text = course.name;
    _teacherController.text = course.teacher;
    _classroomController.text = course.classroom;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑课程'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '课程名称',
                  hintText: '请输入课程名称',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入课程名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(
                  labelText: '授课教师',
                  hintText: '请输入教师姓名',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _classroomController,
                decoration: const InputDecoration(
                  labelText: '教室',
                  hintText: '请输入教室位置',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final updatedCourse = CourseInfo(
                  id: course.id,
                  name: _nameController.text,
                  teacher: _teacherController.text,
                  classroom: _classroomController.text,
                );

                Provider.of<TimetableEditService>(context, listen: false)
                    .updateCourse(updatedCourse);

                Navigator.of(context).pop();
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<TimetableEditService>(
      builder: (context, service, child) {
        final courses = service.courses;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.courseListTitle(courses.length),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddCourseDialog,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addCourse),
                  ),
                ],
              ),
            ),
            Expanded(
              child: courses.isEmpty
                  ? Center(
                      child: Text(l10n.noCourses),
                    )
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(course.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (course.teacher.isNotEmpty)
                                  Text(l10n.teacherPrefix(course.teacher)),
                                if (course.classroom.isNotEmpty)
                                  Text(l10n.classroomPrefix(course.classroom)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showEditCourseDialog(course),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(l10n.confirmDelete),
                                        content: Text(
                                          l10n.deleteCourseConfirm(course.name),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(l10n.cancel),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              service.deleteCourse(course.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(l10n.delete),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
