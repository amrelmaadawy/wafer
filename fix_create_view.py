import re
import sys

def main():
    try:
        with open('lib/features/owner/legal_cases/presentation/views/legal_case_create_view.dart', 'r', encoding='utf-8') as f:
            content = f.read()

        # 1. Replace LegalCaseDetailsSkeleton with CircularProgressIndicator
        content = content.replace('return const LegalCaseDetailsSkeleton();', 'return const Center(child: CircularProgressIndicator());')

        # 2. Fix LocaleKeys.details_and_conclusion
        content = content.replace('LocaleKeys.details_and_conclusion.tr()', 'LocaleKeys.notes.tr()')

        # 3. Remove onInvoiceSelected from LegalCaseLinksCard
        content = re.sub(r'onInvoiceSelected:\s*\(id\)\s*=>\s*setState\(\(\)\s*=>\s*_selectedInvoiceId\s*=\s*id\),', '', content)

        # 4. Remove unused methods _buildCard to end of file
        idx = content.find('  Widget _buildCard({required String title, required List<Widget> children}) {')
        if idx != -1:
            content = content[:idx] + '}\n'

        # 5. Fix _selectDate to actually open the date picker
        date_picker_code = """onSelectDate: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: _hearingDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: context.primaryColor,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (date != null) {
                                          setState(() {
                                            _hearingDate = date;
                                          });
                                        }
                                      },"""
        content = content.replace('onSelectDate: () => _selectDate(context),', date_picker_code)

        # 6. Make sure Scaffold wraps the body properly
        # Find the return MultiBlocProvider line and wrap it? No, the Scaffold is better placed inside the PopScope child.
        
        # Currently we have:
        # child: BlocBuilder<LegalCaseFormDataCubit, LegalCaseFormDataState>(
        # Replace it with:
        # child: Scaffold(
        #   backgroundColor: AppColors.backgroundLight,
        #   appBar: AppBar(
        #     backgroundColor: Colors.white,
        #     title: Text(
        #       isEditMode ? LocaleKeys.edit_legal_case.tr() : LocaleKeys.add_legal_case.tr(),
        #       style: AppTextStyles.h4,
        #     ),
        #     centerTitle: true,
        #   ),
        #   body: BlocBuilder<LegalCaseFormDataCubit, LegalCaseFormDataState>(
        old_child_bloc = 'child: BlocBuilder<LegalCaseFormDataCubit, LegalCaseFormDataState>('
        new_child_bloc = '''child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                isEditMode ? LocaleKeys.edit_legal_case.tr() : LocaleKeys.add_legal_case.tr(),
                style: AppTextStyles.h4,
              ),
              centerTitle: true,
            ),
            body: BlocBuilder<LegalCaseFormDataCubit, LegalCaseFormDataState>('''
        content = content.replace(old_child_bloc, new_child_bloc)

        # And close the Scaffold at the very end. The end has:
        #               },
        #             ),
        #           ),
        #         ),
        #       ),
        #     );
        #   }
        # Since I replaced child: BlocBuilder... with child: Scaffold( body: BlocBuilder..., we need an extra `),`
        # wait, the original file ends with:
        #               },
        #             ),
        #           ),
        #         ),
        #       ),
        #     );
        #   }
        # But wait, my truncation above `idx` ends exactly before `Widget _buildCard`.
        # The line before `Widget _buildCard` is `  }` which closes `Widget build`.
        # If I want to add `),` to close Scaffold, I should find the end of `Widget build`.
        
        # Just replace the end block:
        old_end = '''              },
            ),
          ),
        ),
      ),
    );
  }'''
        new_end = '''              },
            ),
          ),
        ),
      ),
    ));
  }'''
        content = content.replace(old_end, new_end)

        with open('lib/features/owner/legal_cases/presentation/views/legal_case_create_view.dart', 'w', encoding='utf-8') as f:
            f.write(content)
        
        print("Done fixing legal_case_create_view.dart")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    main()
