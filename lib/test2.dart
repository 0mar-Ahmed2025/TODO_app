// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TestState {}

class InitState extends TestState {}

class OnPressedState extends TestState {}

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(InitState());
  static TestCubit get(context) => BlocProvider.of(context);

  bool onPreesed = false;
  Color color = Colors.green;
  double radius = 50;

  onBtnPressed() {
    onPreesed = !onPreesed;
    if (onPreesed) {
      color = Colors.amberAccent;
      radius = 0;
    }
    emit(OnPressedState());
  }
}

class Test2 extends StatelessWidget {
  const Test2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TestCubit(),
      child: Scaffold(
        body: BlocBuilder<TestCubit, TestState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: TestCubit.get(context).onBtnPressed,

                    child: Icon(Icons.add),
                  ),
                ),
                // if (TestCubit.get(context).onPreesed)
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: TestCubit.get(context).color,
                    borderRadius: TestCubit.get(context).onPreesed
                        ? BorderRadius.circular(TestCubit.get(context).radius)
                        : BorderRadius.circular(100),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
