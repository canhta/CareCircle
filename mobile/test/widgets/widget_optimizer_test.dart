import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carecircle/widgets/widget_optimizer.dart';

void main() {
  group('WidgetOptimizer Tests', () {
    testWidgets(
        'optimizedListViewBuilder creates ListView with RepaintBoundary',
        (WidgetTester tester) async {
      final items = List.generate(5, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetOptimizer.optimizedListViewBuilder(
              itemCount: items.length,
              itemBuilder: (context, index) => Text(items[index]),
              addRepaintBoundaries: true,
              addItemKeys: true,
            ),
          ),
        ),
      );

      // Verify all items are rendered
      for (int i = 0; i < items.length; i++) {
        expect(find.text('Item $i'), findsOneWidget);
      }

      // Verify RepaintBoundary widgets are present
      expect(find.byType(RepaintBoundary), findsAtLeast(items.length));

      // Verify KeyedSubtree widgets are present for keys
      expect(find.byType(KeyedSubtree), findsAtLeast(items.length));
    });

    testWidgets('optimizedCard creates Card with RepaintBoundary',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetOptimizer.optimizedCard(
              child: const Text('Card Content'),
              useRepaintBoundary: true,
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsAtLeast(1));
    });

    testWidgets('optimizedListTile creates ListTile with RepaintBoundary',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetOptimizer.optimizedListTile(
              title: const Text('Title'),
              subtitle: const Text('Subtitle'),
              useRepaintBoundary: true,
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsAtLeast(1));
    });

    testWidgets('optimizeColumn creates Column with optional RepaintBoundary',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetOptimizer.optimizeColumn(
              children: const [
                Text('Child 1'),
                Text('Child 2'),
                Text('Child 3'),
              ],
              addRepaintBoundaries: true,
            ),
          ),
        ),
      );

      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
      expect(find.text('Child 3'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(
          find.byType(RepaintBoundary), findsAtLeast(3)); // One for each child
    });

    testWidgets(
        'optimizedRefreshIndicator creates RefreshIndicator with RepaintBoundary',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetOptimizer.optimizedRefreshIndicator(
              onRefresh: () async {
                // Refresh callback for testing
              },
              child: const Text('Refreshable Content'),
              useRepaintBoundary: true,
            ),
          ),
        ),
      );

      expect(find.text('Refreshable Content'), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsAtLeast(1));
    });

    testWidgets('optimizedFutureBuilder handles loading and data states',
        (WidgetTester tester) async {
      final future =
          Future.delayed(const Duration(milliseconds: 100), () => 'Data');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetOptimizer.optimizedFutureBuilder<String>(
              future: future,
              builder: (context, data) => Text('Data: $data'),
              loadingWidget: const Text('Loading...'),
              useRepaintBoundary: true,
            ),
          ),
        ),
      );

      // Initially shows loading
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsAtLeast(1));

      // Wait for future to complete
      await tester.pump(const Duration(milliseconds: 150));

      // Now shows data
      expect(find.text('Data: Data'), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);
    });

    testWidgets('optimizedStreamBuilder handles stream data',
        (WidgetTester tester) async {
      final controller = StreamController<String>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetOptimizer.optimizedStreamBuilder<String>(
              stream: controller.stream,
              builder: (context, data) => Text('Stream: $data'),
              loadingWidget: const Text('Waiting...'),
              useRepaintBoundary: true,
            ),
          ),
        ),
      );

      // Initially shows loading
      expect(find.text('Waiting...'), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsAtLeast(1));

      // Add data to stream
      controller.add('Stream Data');
      await tester.pump();

      // Now shows stream data
      expect(find.text('Stream: Stream Data'), findsOneWidget);
      expect(find.text('Waiting...'), findsNothing);

      controller.close();
    });

    test('optimizedListViewBuilder parameters are correctly passed', () {
      // Test that all parameters are properly forwarded to ListView.builder
      // This is more of a structural test since we can't easily test internal ListView properties

      final widget = WidgetOptimizer.optimizedListViewBuilder(
        itemCount: 10,
        itemBuilder: (context, index) => Text('Item $index'),
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        addRepaintBoundaries: false,
        addItemKeys: false,
      );

      expect(widget, isA<ListView>());
    });
  });
}
