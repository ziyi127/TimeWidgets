# Requirements Document

## Introduction

本功能旨在完善 Flutter 课表应用的设置界面和课表编辑界面，使其完全遵循 Material Design 3 (MD3) 设计规范，并参考 ClassIsland (https://github.com/ClassIsland/ClassIsland) 的课表编辑逻辑进行优化。当前实现已有部分 MD3 样式工具类，但设置界面和课表编辑子界面（课程编辑、时间段编辑、日课表编辑）的组件样式不够统一，编辑交互也需要参考 ClassIsland 进行改进。

## Glossary

- **MD3**: Material Design 3，Google 最新的设计系统规范
- **Settings_Screen**: 应用设置界面，包含外观、通知、数据刷新等配置项
- **Timetable_Edit_Screen**: 课表编辑主界面，包含三个子标签页
- **Course_Edit_Screen**: 课程编辑界面，管理课程信息（名称、教师、教室）
- **Time_Slot_Edit_Screen**: 时间段编辑界面，管理上课时间段
- **Daily_Course_Edit_Screen**: 日课表编辑界面，为每天每个时间段分配课程
- **Surface_Container**: MD3 中用于内容容器的表面颜色层级
- **Filled_Button**: MD3 主要操作按钮样式
- **Filled_Tonal_Button**: MD3 次要强调按钮样式
- **Input_Chip**: MD3 输入型芯片组件
- **Segmented_Button**: MD3 分段按钮组件
- **ClassIsland**: 一款开源的课表管理软件，本项目参考其课表编辑逻辑
- **Time_Layout**: ClassIsland 中的时间布局概念，定义一天中的时间段安排
- **Class_Plan**: ClassIsland 中的课程计划概念，定义某天某时间段的课程安排

## Requirements

### Requirement 1

**User Story:** As a user, I want the settings screen to follow MD3 design patterns, so that I have a consistent and modern visual experience.

#### Acceptance Criteria

1. WHEN the settings screen loads THEN the Settings_Screen SHALL display all setting groups using MD3 Surface_Container cards with proper elevation and corner radius
2. WHEN a user interacts with toggle settings THEN the Settings_Screen SHALL use MD3 Switch components with proper color tokens
3. WHEN a user interacts with selection settings THEN the Settings_Screen SHALL use MD3 Dropdown menus with proper styling
4. WHEN displaying section headers THEN the Settings_Screen SHALL use MD3 typography styles (titleMedium) with proper color tokens
5. WHEN displaying list items THEN the Settings_Screen SHALL use consistent MD3 ListTile styling with proper icon and text colors

### Requirement 2

**User Story:** As a user, I want the course edit screen to follow MD3 design patterns, so that I can manage courses with a modern and intuitive interface.

#### Acceptance Criteria

1. WHEN the course list displays THEN the Course_Edit_Screen SHALL render course items using MD3 Surface_Container cards
2. WHEN a user adds or edits a course THEN the Course_Edit_Screen SHALL display a MD3 styled dialog with proper Surface_Container_Highest background
3. WHEN displaying form fields THEN the Course_Edit_Screen SHALL use MD3 outlined text fields with proper label and border styling
4. WHEN displaying action buttons THEN the Course_Edit_Screen SHALL use MD3 Filled_Button for primary actions and Text buttons for secondary actions
5. WHEN displaying the add course button THEN the Course_Edit_Screen SHALL use MD3 Filled_Tonal_Button with icon

### Requirement 3

**User Story:** As a user, I want the time slot edit screen to follow MD3 design patterns, so that I can manage class schedules with a consistent visual style.

#### Acceptance Criteria

1. WHEN the time slot list displays THEN the Time_Slot_Edit_Screen SHALL render time slot items using MD3 Surface_Container cards
2. WHEN a user selects time THEN the Time_Slot_Edit_Screen SHALL use MD3 styled time picker with proper color tokens
3. WHEN displaying time input fields THEN the Time_Slot_Edit_Screen SHALL use MD3 outlined input decorators with proper styling
4. WHEN displaying action buttons THEN the Time_Slot_Edit_Screen SHALL use MD3 button hierarchy (Filled for primary, Text for cancel)
5. WHEN displaying the add time slot button THEN the Time_Slot_Edit_Screen SHALL use MD3 Filled_Tonal_Button with icon

### Requirement 4

**User Story:** As a user, I want the daily course edit screen to follow MD3 design patterns, so that I can assign courses to time slots with a clear and organized interface.

#### Acceptance Criteria

1. WHEN displaying day and week type selectors THEN the Daily_Course_Edit_Screen SHALL use MD3 Segmented_Button or styled dropdown menus
2. WHEN displaying the timetable grid header THEN the Daily_Course_Edit_Screen SHALL use MD3 Surface_Container with proper color tokens
3. WHEN displaying course selectors THEN the Daily_Course_Edit_Screen SHALL use MD3 styled dropdown buttons with proper borders and colors
4. WHEN no selection is made THEN the Daily_Course_Edit_Screen SHALL display empty state with MD3 typography and proper color tokens
5. WHEN displaying time information THEN the Daily_Course_Edit_Screen SHALL use MD3 labelSmall typography with onSurfaceVariant color

### Requirement 5

**User Story:** As a user, I want all dialogs in the timetable edit screens to follow MD3 design patterns, so that modal interactions feel consistent with the rest of the app.

#### Acceptance Criteria

1. WHEN a dialog opens THEN the system SHALL display it with MD3 dialog styling including proper corner radius (28dp) and surface tint
2. WHEN displaying dialog titles THEN the system SHALL use MD3 headlineSmall typography
3. WHEN displaying dialog content THEN the system SHALL use proper MD3 spacing (24dp padding)
4. WHEN displaying dialog actions THEN the system SHALL align buttons to the end with proper MD3 spacing (8dp between buttons)
5. WHEN displaying confirmation dialogs THEN the system SHALL use MD3 error color tokens for destructive actions

### Requirement 6

**User Story:** As a user, I want visual feedback when interacting with list items, so that I know my interactions are being registered.

#### Acceptance Criteria

1. WHEN a user taps on a list item THEN the system SHALL display MD3 ripple effect with proper color tokens
2. WHEN a user hovers over a list item THEN the system SHALL display MD3 hover state with proper opacity
3. WHEN a list item is in pressed state THEN the system SHALL display MD3 pressed state with proper color overlay
4. WHEN displaying icon buttons THEN the system SHALL use MD3 icon button styling with proper touch targets (48dp minimum)

### Requirement 7

**User Story:** As a user, I want empty states to be clearly communicated, so that I understand when there is no data and what action to take.

#### Acceptance Criteria

1. WHEN a list is empty THEN the system SHALL display an empty state message using MD3 bodyLarge typography
2. WHEN displaying empty state THEN the system SHALL use onSurfaceVariant color for the message text
3. WHEN an empty state has a suggested action THEN the system SHALL display a MD3 Filled_Tonal_Button to guide the user

### Requirement 8

**User Story:** As a developer, I want the MD3 styling to be applied consistently through reusable utility classes, so that the codebase remains maintainable.

#### Acceptance Criteria

1. WHEN applying MD3 styles THEN the implementation SHALL use existing MD3CardStyles utility class for all card components
2. WHEN applying MD3 styles THEN the implementation SHALL use existing MD3ButtonStyles utility class for all button components
3. WHEN applying MD3 styles THEN the implementation SHALL use existing MD3TypographyStyles utility class for all text styling
4. WHEN new MD3 components are needed THEN the implementation SHALL extend existing utility classes rather than inline styling

### Requirement 9

**User Story:** As a user, I want the timetable edit screen to have a clear tab-based structure similar to ClassIsland (课表、时间表、科目), so that I can easily navigate between different editing sections.

#### Acceptance Criteria

1. WHEN the timetable edit screen loads THEN the Timetable_Edit_Screen SHALL display three tabs: 课表(Schedule), 时间表(Time Layout), 科目(Subjects)
2. WHEN switching tabs THEN the Timetable_Edit_Screen SHALL use MD3 tab bar with proper indicator animation
3. WHEN displaying each tab THEN the Timetable_Edit_Screen SHALL show a list view on the left and detail editor on the right (master-detail layout)
4. WHEN no item is selected THEN the Timetable_Edit_Screen SHALL display an empty state prompting user to select or create an item

### Requirement 10

**User Story:** As a user, I want to manage time layouts (时间表) similar to ClassIsland with timeline view, so that I can visually arrange class times and breaks.

#### Acceptance Criteria

1. WHEN editing time slots THEN the Time_Slot_Edit_Screen SHALL display a timeline view showing all time points in chronological order
2. WHEN a user creates a time point THEN the Time_Slot_Edit_Screen SHALL allow specifying type: 上课(class), 课间休息(break), 分割线(divider)
3. WHEN displaying time points THEN the Time_Slot_Edit_Screen SHALL visually distinguish types using MD3 color tokens (primary for class, surfaceVariant for break)
4. WHEN a user drags a time point THEN the Time_Slot_Edit_Screen SHALL support drag-and-drop to adjust start and end times
5. WHEN displaying class time points THEN the Time_Slot_Edit_Screen SHALL show duration and allow setting default subject

### Requirement 11

**User Story:** As a user, I want to edit course schedules (课表) with trigger rules similar to ClassIsland, so that schedules can auto-activate based on conditions.

#### Acceptance Criteria

1. WHEN creating a schedule THEN the Course_Edit_Screen SHALL allow setting trigger rules (weekday, week type)
2. WHEN editing a schedule THEN the Course_Edit_Screen SHALL display a grid with time slots as rows and allow assigning subjects
3. WHEN a schedule matches current conditions THEN the system SHALL auto-activate that schedule
4. WHEN multiple schedules match THEN the system SHALL use priority order to determine which schedule to activate
5. WHEN displaying schedules THEN the Course_Edit_Screen SHALL show schedule name, associated time layout, and activation status

### Requirement 12

**User Story:** As a user, I want to manage subjects (科目) with detailed information similar to ClassIsland, so that I can track teacher and course details.

#### Acceptance Criteria

1. WHEN adding a subject THEN the Course_Edit_Screen SHALL allow entering: name, abbreviation, teacher name, and color
2. WHEN displaying subjects THEN the Course_Edit_Screen SHALL show a table view with all subject information
3. WHEN editing a subject THEN the Course_Edit_Screen SHALL display a detail panel on the right side
4. WHEN a subject is used in schedules THEN the system SHALL prevent deletion and show usage information
5. WHEN displaying subject color THEN the Course_Edit_Screen SHALL show a color indicator chip next to the subject name

### Requirement 13

**User Story:** As a user, I want to assign courses with week type support (每周/单周/双周), so that I can handle alternating schedules.

#### Acceptance Criteria

1. WHEN assigning a subject to a time slot THEN the Daily_Course_Edit_Screen SHALL provide week type selection (每周, 单周, 双周)
2. WHEN displaying assigned subjects THEN the Daily_Course_Edit_Screen SHALL show week type badge for non-every-week assignments
3. WHEN a time slot has different subjects for odd and even weeks THEN the Daily_Course_Edit_Screen SHALL display both with clear visual distinction
4. WHEN viewing the schedule THEN the Daily_Course_Edit_Screen SHALL allow filtering by week type

### Requirement 14

**User Story:** As a user, I want subjects to have customizable colors, so that I can visually distinguish different subjects in the timetable.

#### Acceptance Criteria

1. WHEN adding or editing a subject THEN the system SHALL provide a MD3 color picker dialog for selecting subject color
2. WHEN displaying subjects in the schedule grid THEN the system SHALL use the subject color as background with appropriate text contrast
3. WHEN no color is specified THEN the system SHALL generate a color based on the subject name hash
4. WHEN displaying the subject list THEN the system SHALL show a color indicator for each subject

### Requirement 15

**User Story:** As a user, I want to import and export timetable data compatible with ClassIsland format, so that I can share schedules between applications.

#### Acceptance Criteria

1. WHEN importing from ClassIsland THEN the system SHALL correctly parse Subjects, TimeLayouts, and ClassPlans
2. WHEN exporting data THEN the system SHALL generate JSON format compatible with the application data model
3. WHEN import encounters errors THEN the system SHALL display clear error messages with MD3 error styling
4. WHEN import succeeds THEN the system SHALL display a success snackbar with imported item counts
