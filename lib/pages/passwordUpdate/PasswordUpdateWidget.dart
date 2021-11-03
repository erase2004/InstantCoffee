import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/pages/passwordUpdate/oldPasswordConfirmForm.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdateErrorWidget.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdateForm.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdateSuccessWidget.dart';

class PasswordUpdateWidget extends StatefulWidget {
  PasswordUpdateWidget();

  @override
  _PasswordUpdateWidgetState createState() => _PasswordUpdateWidgetState();
}

class _PasswordUpdateWidgetState extends State<PasswordUpdateWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordUpdateBloc, PasswordUpdateState>(
      builder: (BuildContext context, PasswordUpdateState state) {
        if (state is PasswordUpdateError) {
          final error = state.error;
          print('EmailLoginError: ${error.message}');
          return PasswordUpdateErrorWidget();
        }
        if (state is OldPasswordConfirm) {
          return OldPasswordConfirmForm(
            oldPasswordConfirm: state,
          );
        }
        if (state is PasswordUpdateSuccess) {
          context.read<LoginBloc>().add(SignOut());
          return PasswordUpdateSuccessWidget();
        }

        // state is Password Update Init, Loading 
        return PasswordUpdateForm(
          passwordUpdateState: state,
        );
      }
    );
  }
}