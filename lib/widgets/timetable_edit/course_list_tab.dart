import 'package:flutter/material.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_edit_service.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_dialog_styles.dart';
import 'package:time_widgets/utils/md3_form_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';

class CourseListTab extends StatefulWidget {
  const CourseListTab({super.key, required this.service});
  final TimetableEditService service;

  @override
  State<CourseListTab> createState() => _CourseListTabState();
}

// 排序字段枚举
enum SortField {
  name,
  abbreviation,
  teacher,
  classroom,
}

// 排序顺序枚举
enum SortOrder {
  ascending,
  descending,
}

class _CourseListTabState extends State<CourseListTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  SortField _sortField = SortField.name;
  SortOrder _sortOrder = SortOrder.ascending;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter and sort courses
  List<CourseInfo> get _filteredCourses {
    // Create a modifiable copy of the courses list first
    List<CourseInfo> filtered = List.from(widget.service.courses);

    // Filter if needed
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((course) {
        return course.name.toLowerCase().contains(query) ||
            course.abbreviation.toLowerCase().contains(query) ||
            course.teacher.toLowerCase().contains(query) ||
            course.classroom.toLowerCase().contains(query);
      }).toList();
    }

    // Then sort the modifiable list
    filtered.sort((a, b) {
      int comparison;

      switch (_sortField) {
        case SortField.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortField.abbreviation:
          comparison = a.abbreviation.compareTo(b.abbreviation);
          break;
        case SortField.teacher:
          comparison = a.teacher.compareTo(b.teacher);
          break;
        case SortField.classroom:
          comparison = a.classroom.compareTo(b.classroom);
          break;
      }

      return _sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return filtered;
  }

  // Get sort field display name
  String _getSortFieldName() {
    return _getSortFieldNameForField(_sortField);
  }

  // Get sort field display name for a specific field
  String _getSortFieldNameForField(SortField field) {
    switch (field) {
      case SortField.name:
        return '名称';
      case SortField.abbreviation:
        return '简称';
      case SortField.teacher:
        return '教师';
      case SortField.classroom:
        return '教室';
    }
  }

  // Toggle sort order
  void _toggleSortOrder() {
    setState(() {
      _sortOrder = _sortOrder == SortOrder.ascending
          ? SortOrder.descending
          : SortOrder.ascending;
    });
  }

  // Change sort field
  void _changeSortField(SortField field) {
    setState(() {
      _sortField = field;
    });
  }

  /// Generate a simple unique ID using timestamp and random numbers
  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond % 1000;
    return 'course_${timestamp}_$random';
  }

  /// Show a color picker dialog with predefined colors
  Future<Color?> _showColorPickerDialog(
      BuildContext context, Color initialColor) async {
    final colorScheme = Theme.of(context).colorScheme;
    Color selectedColor = initialColor;

    // Expanded color palette with more options
    final colors = [
      // 红色系
      Colors.red[500]!, Colors.red[700]!, Colors.red[300]!,
      Colors.pink[500]!, Colors.pink[700]!, Colors.pink[300]!,
      // 紫色系
      Colors.purple[500]!, Colors.purple[700]!, Colors.purple[300]!,
      Colors.deepPurple[500]!, Colors.deepPurple[700]!, Colors.deepPurple[300]!,
      // 蓝色系
      Colors.indigo[500]!, Colors.indigo[700]!, Colors.indigo[300]!,
      Colors.blue[500]!, Colors.blue[700]!, Colors.blue[300]!,
      Colors.lightBlue[500]!, Colors.lightBlue[700]!, Colors.lightBlue[300]!,
      // 青色系
      Colors.cyan[500]!, Colors.cyan[700]!, Colors.cyan[300]!,
      Colors.teal[500]!, Colors.teal[700]!, Colors.teal[300]!,
      // 绿色系
      Colors.green[500]!, Colors.green[700]!, Colors.green[300]!,
      Colors.lightGreen[500]!, Colors.lightGreen[700]!, Colors.lightGreen[300]!,
      Colors.lime[500]!, Colors.lime[700]!, Colors.lime[300]!,
      // 黄色系
      Colors.yellow[500]!, Colors.yellow[700]!, Colors.yellow[300]!,
      Colors.amber[500]!, Colors.amber[700]!, Colors.amber[300]!,
      // 橙色系
      Colors.orange[500]!, Colors.orange[700]!, Colors.orange[300]!,
      Colors.deepOrange[500]!, Colors.deepOrange[700]!, Colors.deepOrange[300]!,
      // 中性色系
      Colors.brown[500]!, Colors.brown[700]!, Colors.brown[300]!,
      Colors.grey[500]!, Colors.grey[700]!, Colors.grey[300]!,
      Colors.blueGrey[500]!, Colors.blueGrey[700]!, Colors.blueGrey[300]!,
    ];

    return showDialog<Color>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('选择科目颜色'),
          content: SizedBox(
            width: 320,
            height: 240,
            child: Column(
              children: [
                // Color preview
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  alignment: Alignment.center,
                  child: Text(
                    '预览颜色',
                    style: TextStyle(
                      color: selectedColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Color grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    padding: EdgeInsets.zero,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final color = colors[index];
                      final isSelected =
                          selectedColor.toARGB32() == color.toARGB32();
                      return InkWell(
                        onTap: () => setState(() => selectedColor = color),
                        borderRadius: BorderRadius.circular(20),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: colorScheme.primary,
                                    width: 3,
                                  )
                                : Border.all(
                                    color: colorScheme.outlineVariant,
                                  ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: color.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      );
                    },
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
            FilledButton(
              onPressed: () => Navigator.of(context).pop(selectedColor),
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filteredCourses;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: MD3FormStyles.outlinedTextField(
              context: context,
              controller: _searchController,
              label: '搜索科目',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Search results count and sort controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search results count
                if (_searchQuery.isNotEmpty)
                  Text(
                    '找到 ${courses.length} 个科目',
                    style: MD3TypographyStyles.bodySmall(context),
                  ),
                // Sort controls
                Row(
                  children: [
                    Text(
                      '排序:',
                      style: MD3TypographyStyles.bodySmall(context),
                    ),
                    const SizedBox(width: 8),
                    // Sort field dropdown
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _getSortFieldName(),
                        onChanged: (value) {
                          // Find the corresponding SortField
                          for (final field in SortField.values) {
                            if (_getSortFieldNameForField(field) == value) {
                              _changeSortField(field);
                              break;
                            }
                          }
                        },
                        items: SortField.values.map((field) {
                          return DropdownMenuItem<String>(
                            value: _getSortFieldNameForField(field),
                            child: Text(
                              _getSortFieldNameForField(field),
                              style: MD3TypographyStyles.bodySmall(context),
                            ),
                          );
                        }).toList(),
                        style: MD3TypographyStyles.bodySmall(context),
                        icon: const Icon(Icons.arrow_drop_down, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort order toggle
                    IconButton(
                      icon: Icon(
                        _sortOrder == SortOrder.ascending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 18,
                      ),
                      onPressed: _toggleSortOrder,
                      tooltip: _sortOrder == SortOrder.ascending ? '升序' : '降序',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Course list
          Expanded(
            child: courses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty
                              ? Icons.search_off_outlined
                              : Icons.class_outlined,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty ? '没有找到匹配的科目' : '暂无科目',
                          style: MD3TypographyStyles.titleMedium(context),
                        ),
                        const SizedBox(height: 8),
                        if (_searchQuery.isNotEmpty)
                          Text('尝试调整搜索条件',
                              style: MD3TypographyStyles.bodyMedium(context)),
                        if (!_searchQuery.isNotEmpty)
                          Text('点击下方按钮添加科目',
                              style: MD3TypographyStyles.bodyMedium(context)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MD3CardStyles.surfaceContainer(
                          context: context,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(int.parse(
                                  course.color.replaceFirst('#', '0xFF'))),
                              child: Text(
                                course.name.isNotEmpty ? course.name[0] : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(course.name,
                                style:
                                    MD3TypographyStyles.titleMedium(context)),
                            subtitle: Text(
                              [
                                if (course.teacher.isNotEmpty) course.teacher,
                                if (course.classroom.isNotEmpty)
                                  course.classroom,
                              ].join(' · '),
                              style: MD3TypographyStyles.bodySmall(context),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _showEditDialog(context, course),
                            ),
                            onLongPress: () => _confirmDelete(context, course),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(context, null),
        icon: const Icon(Icons.add),
        label: const Text('添加科目'),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, CourseInfo? course) async {
    final isEditing = course != null;
    final nameController = TextEditingController(text: course?.name);
    final abbrController = TextEditingController(text: course?.abbreviation);
    final teacherController = TextEditingController(text: course?.teacher);
    final classroomController = TextEditingController(text: course?.classroom);
    Color selectedColor = course != null
        ? Color(int.parse(course.color.replaceFirst('#', '0xFF')))
        : Colors.blue;
    bool isOutdoor = course?.isOutdoor ?? false;
    String? nameError;

    // 生成课程简称
    String generateAbbreviation(String name) {
      if (name.isEmpty) return '';

      // 如果是中文，取每个字的首字母
      if (RegExp(r'[\u4e00-\u9fa5]').hasMatch(name)) {
        final chars = name.split('');
        final abbreviation = chars.take(3).join();
        return abbreviation;
      }
      // 如果是英文，取每个单词的首字母
      else {
        final words = name.split(RegExp(r'\s+'));
        final abbreviation = words
            .map((word) => word.isNotEmpty ? word[0] : '')
            .join()
            .toUpperCase();
        return abbreviation.substring(
            0, abbreviation.length > 3 ? 3 : abbreviation.length);
      }
    }

    // 实时验证课程名称并自动生成简称
    void validateName(String value) {
      if (value.isEmpty) {
        nameError = '请输入科目名称';
      } else if (value.length > 20) {
        nameError = '科目名称不能超过20个字符';
      } else {
        nameError = null;
        // 只有当用户没有手动输入简称时，才自动生成
        if (abbrController.text.isEmpty ||
            abbrController.text == course?.abbreviation) {
          abbrController.text = generateAbbreviation(value);
        }
      }
    }

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEditing ? '编辑科目' : '添加科目'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MD3FormStyles.outlinedTextField(
                        context: context,
                        controller: nameController,
                        label: '科目名称',
                        prefixIcon: const Icon(Icons.book_outlined),
                        onChanged: (value) {
                          setState(() {
                            validateName(value);
                          });
                        },
                        errorText: nameError,
                      ),
                      if (nameError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 4),
                          child: Text(
                            nameError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MD3FormStyles.outlinedTextField(
                    context: context,
                    controller: abbrController,
                    label: '简称（选填）',
                    prefixIcon: const Icon(Icons.short_text),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  MD3FormStyles.outlinedTextField(
                    context: context,
                    controller: teacherController,
                    label: '教师（选填）',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 16),
                  MD3FormStyles.outlinedTextField(
                    context: context,
                    controller: classroomController,
                    label: '教室（选填）',
                    prefixIcon: const Icon(Icons.room_outlined),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('颜色标识'),
                    trailing: GestureDetector(
                      onTap: () async {
                        final color = await _showColorPickerDialog(
                            context, selectedColor);
                        if (color != null) {
                          setState(() => selectedColor = color);
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color:
                                  Colors.grey.withAlpha((255 * 0.5).round())),
                        ),
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('户外课程'),
                    value: isOutdoor,
                    onChanged: (value) => setState(() => isOutdoor = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  // 再次验证确保所有条件都满足
                  validateName(nameController.text);
                  if (nameError != null) {
                    setState(() {});
                    return;
                  }

                  final newCourse = CourseInfo(
                    id: course?.id ?? _generateId(),
                    name: nameController.text,
                    abbreviation: abbrController.text,
                    teacher: teacherController.text,
                    classroom: classroomController.text,
                    color:
                        '#${selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
                    isOutdoor: isOutdoor,
                  );

                  if (isEditing) {
                    widget.service.updateCourse(newCourse);
                  } else {
                    widget.service.addCourse(newCourse);
                  }
                  Navigator.pop(context);
                },
                child: const Text('保存'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, CourseInfo course) async {
    // Check if the course is in use
    final usages = widget.service.findSubjectUsages(course.id);
    String message = '确定要删除科目"${course.name}"吗？';

    if (usages.isNotEmpty) {
      message += ' 该科目正在被使用：\n';
      for (final usage in usages) {
        message += '- ${usage.description}\n';
      }
      message += '删除后相关课程安排也将被移除。';
    } else {
      message += ' 删除后相关课程安排也将被移除。';
    }

    final confirmed = await MD3DialogStyles.showConfirmDialog(
      context: context,
      title: '删除科目',
      message: message,
      confirmText: '删除',
      isDestructive: true,
    );

    if (confirmed ?? false) {
      widget.service.deleteCourse(course.id);
    }
  }
}
