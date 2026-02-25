import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/core/config/app_config.dart';
import 'package:riverpod3_2026/features/home/presentation/controllers/home_notifier_provider.dart';
import 'package:riverpod3_2026/features/products/presentation/models/product_ui_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(appConfigProvider);
    final homeState = ref.watch(homeProvider);
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                ref.read(homeProvider.notifier).loadMore();
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('Home ${appConfig.appFlavor}'),
                  pinned: false,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Promotions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 16.0),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 280,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'Promotion ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Product Items',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: homeState.when(
                    data: (data) => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: data.length,
                        (context, index) {
                          final item = data[index];
                          return switch (item) {
                            NormalProductUiItem() => Card(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                leading: Image.network(
                                  item.imageUrl,
                                  width: 60,
                                  height: 60,
                                ),
                                title: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  item.description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                trailing: Text(
                                  '\$${item.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            LoadingMoreItem() => const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            ErrorMoreItem() => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: Text(item.error),
                                onPressed: () {
                                  // ตัด Error ทิ้งแล้วลองโหลดใหม่
                                  ref.read(homeProvider.notifier).loadMore();
                                },
                              ),
                            ),
                          };
                        },
                      ),
                    ),
                    error: (error, stackTrace) => const SliverToBoxAdapter(
                      child: Center(child: Text('Error loading data')),
                    ),
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                // Add some bottom padding for the bottom navigation bar
                const SliverPadding(padding: EdgeInsets.only(bottom: 48.0)),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CallOrderActionPanel(),
            ),
          ),
        ],
      ),
    );
  }
}

class CallOrderActionPanel extends HookConsumerWidget {
  const CallOrderActionPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = useState(false);

    return GestureDetector(
      onTap: () => expanded.value = !expanded.value,
      child: AnimatedCrossFade(
        firstCurve: Curves.easeInOut,
        secondCurve: Curves.easeInOut,
        sizeCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
        crossFadeState: expanded.value
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: Container(
          padding: const EdgeInsets.all(12.0),
          width: double.infinity,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: const Text("Call order"),
        ),
        secondChild: Container(
          padding: const EdgeInsets.all(12.0),
          width: double.infinity,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Call order"),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  "Call order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Home Screen')
Widget homeScreenPreview() {
  return const HomeScreen();
}
