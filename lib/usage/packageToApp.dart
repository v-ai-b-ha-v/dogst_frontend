import 'dart:math';

import 'package:dogst_ui/usage/model/appusage.dart';
import 'package:installed_apps/index.dart';
import 'package:usage_stats/usage_stats.dart';

class PackagetoAppName {
  final Map<String, String> packagetoApp = {};
  List<AppUsage> _processedUsage = [];

  Future<void> init() async {
    List<AppInfo> installedApps = await InstalledApps.getInstalledApps(false, true);
    for (AppInfo app in installedApps) {
      packagetoApp[app.packageName] = app.name;
    }
  }

  void _loadUsageFromEvents(List<EventUsageInfo> events) {
  final Map<String, int> usageMap = {};
  final Map<String, int> foregroundStart = {};

  // First, convert and sort safely
  events.sort((a, b) {
    final aTime = int.tryParse(a.timeStamp?.toString() ?? "0") ?? 0;
    final bTime = int.tryParse(b.timeStamp?.toString() ?? "0") ?? 0;
    return aTime.compareTo(bTime);
  });

  for (final event in events) {
    final pkg = event.packageName;
    final type = event.eventType;
    final time = int.tryParse(event.timeStamp?.toString() ?? "");

    if (pkg == null || type == null || time == null) continue;

    if (type == '1') {
      // MOVE_TO_FOREGROUND
      foregroundStart[pkg] = time;
    } else if (type == '2' && foregroundStart.containsKey(pkg)) {
      // MOVE_TO_BACKGROUND
      final start = foregroundStart[pkg]!;
      final duration = time - start;

      if (duration > 0 && duration < 1000 * 60 * 60) {
        usageMap[pkg] = (usageMap[pkg] ?? 0) + duration;
      }

      foregroundStart.remove(pkg);
    }
  }

  _processedUsage = usageMap.entries.map((entry) {
    final appName = packagetoApp[entry.key] ?? entry.key;
    return AppUsage(
      appName: appName,
      packageName: entry.key,
      usageMillis: entry.value,
    );
  }).toList();
}


  Future<void> fetchAndProcessUsage(DateTime start, DateTime end) async {
    List<EventUsageInfo> events = await UsageStats.queryEvents(start, end);
    _loadUsageFromEvents(events);
  }

  List<AppUsage> getSortedByUsage() {
  final filtered = _processedUsage
      .where((app) => app.usageMillis > 60000)
      .toList();

  filtered.sort((a, b) => b.usageMillis.compareTo(a.usageMillis));
  return filtered;
}

  List<AppUsage> getTopN(int n) {
    n = min(n, _processedUsage.length);
    return getSortedByUsage().take(n).toList();
  }

  Future<int> _getScreenTimeBetween(DateTime start, DateTime end) async {
  await fetchAndProcessUsage(start, end);
  
  // Only include apps with more than 1 min usage
  final filtered = _processedUsage.where((app) => app.usageMillis > 90000);

  return (filtered.fold(0, (sum, app) => sum + app.usageMillis) / 60000).toInt();
}


  Future<int> getTodayScreenTime() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return _getScreenTimeBetween(todayStart, now);
  }

  Future<List<int>> getPrevAndCurrentDayUsage() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(Duration(days: 1));

    final prevDayUsage = await _getScreenTimeBetween(yesterdayStart, todayStart);
    final currentDayUsage = await _getScreenTimeBetween(todayStart, now);

    return [prevDayUsage, currentDayUsage];
  }

  List<AppUsage> getAll() {
    return _processedUsage;
  }
}
