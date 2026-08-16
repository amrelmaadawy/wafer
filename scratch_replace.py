import re

with open(r'f:\flutter projects\codra\wafer\lib\features\owner\tasks\presentation\screens\owner_task_details_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace _showStatusBottomSheet
content = re.sub(
    r'void _showStatusBottomSheet\(BuildContext context\) \{.*?\}\s*(?=Widget _buildInfoChip)',
    '''void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => TaskDetailsStatusBottomSheet(
        formDataCubit: _formDataCubit,
        updateStatusCubit: _updateStatusCubit,
        taskId: widget.taskId,
      ),
    );
  }

  ''',
    content,
    flags=re.DOTALL
)

# Replace _showProgressBottomSheet
content = re.sub(
    r'void _showProgressBottomSheet\(BuildContext context, int initialProgress\) \{.*?\}\s*(?=void _showPriorityBottomSheet)',
    '''void _showProgressBottomSheet(BuildContext context, int initialProgress) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => TaskDetailsProgressBottomSheet(
        updateProgressCubit: _updateProgressCubit,
        taskId: widget.taskId,
        initialProgress: initialProgress,
      ),
    );
  }

  ''',
    content,
    flags=re.DOTALL
)

# Replace _showPriorityBottomSheet
content = re.sub(
    r'void _showPriorityBottomSheet\(BuildContext context, String currentPriority\) \{.*?\}\s*(?=void _showUpdateDatesBottomSheet)',
    '''void _showPriorityBottomSheet(BuildContext context, String currentPriority) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => TaskDetailsPriorityBottomSheet(
        formDataCubit: _formDataCubit,
        updatePriorityCubit: _updatePriorityCubit,
        taskId: widget.taskId,
      ),
    );
  }

  ''',
    content,
    flags=re.DOTALL
)

# Replace _showUpdateDatesBottomSheet
content = re.sub(
    r'void _showUpdateDatesBottomSheet\(BuildContext context, TaskDatesEntity currentDates\) \{.*?\}\s*(?=Widget _buildShimmer)',
    '''void _showUpdateDatesBottomSheet(BuildContext context, TaskDatesEntity currentDates) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appSurfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => TaskDetailsDatesBottomSheet(
        updateDatesCubit: _updateDatesCubit,
        taskId: widget.taskId,
        currentDates: currentDates,
      ),
    );
  }

  ''',
    content,
    flags=re.DOTALL
)

# Add imports if missing
imports = """import '../widgets/details/task_details_status_bottom_sheet.dart';
import '../widgets/details/task_details_progress_bottom_sheet.dart';
import '../widgets/details/task_details_priority_bottom_sheet.dart';
import '../widgets/details/task_details_dates_bottom_sheet.dart';
"""
if 'task_details_status_bottom_sheet.dart' not in content:
    content = content.replace("import '../widgets/task_comments_section.dart';", f"import '../widgets/task_comments_section.dart';\n{imports}")

with open(r'f:\flutter projects\codra\wafer\lib\features\owner\tasks\presentation\screens\owner_task_details_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print(len(content.splitlines()))
