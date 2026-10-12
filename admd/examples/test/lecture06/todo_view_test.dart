// The widget layer: wrap the view in BlocProvider.value with a bloc the test
// controls, and assert what is on screen and which events the view sends.
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_examples/lecture06_bloc/todos/bloc/todo_bloc.dart';
import 'package:flutter_examples/lecture06_bloc/todos/data/todo.dart';
import 'package:flutter_examples/lecture06_bloc/todos/view/todo_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoBloc extends MockBloc<TodoEvent, TodoState> implements TodoBloc {}

void main() {
  late MockTodoBloc bloc;

  setUp(() => bloc = MockTodoBloc());

  Widget view() => MaterialApp(
    home: Scaffold(
      body: BlocProvider<TodoBloc>.value(value: bloc, child: const TodoView()),
    ),
  );

  testWidgets('shows one row per todo', (tester) async {
    when(() => bloc.state).thenReturn(
      const TodoState(
        status: Status.ready,
        todos: [
          Todo(id: '1', title: 'milk'),
          Todo(id: '2', title: 'bread', done: true),
        ],
      ),
    );

    await tester.pumpWidget(view());

    expect(find.text('milk'), findsOneWidget);
    expect(find.text('bread'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('shows a progress bar while loading', (tester) async {
    when(() => bloc.state).thenReturn(const TodoState(status: Status.loading));

    await tester.pumpWidget(view());

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('tapping a row sends TodoToggled', (tester) async {
    when(() => bloc.state).thenReturn(
      const TodoState(
        status: Status.ready,
        todos: [Todo(id: '1', title: 'milk')],
      ),
    );

    await tester.pumpWidget(view());
    await tester.tap(find.text('milk'));

    verify(() => bloc.add(const TodoToggled('1'))).called(1);
  });
}
