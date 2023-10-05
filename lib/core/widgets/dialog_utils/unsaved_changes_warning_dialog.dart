import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class UnsavedChangesWarningDialog extends StatelessWidget {
  const UnsavedChangesWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Discard changes?"),
      content: Text(
        "You have unsaved changes. Do you want to continue without saving? Your changes will be discarded.",
      ),
      actions: [
        DialogCancelButton(),
        DialogConfirmButton(
          label: S.of(context)!.continueLabel,
        ),
      ],
    );
  }
}