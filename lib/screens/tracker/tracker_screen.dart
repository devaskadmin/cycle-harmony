import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/cycle_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/prediction_card.dart';
import '../../widgets/indicators/cycle_progress_ring.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CycleProvider>(
      builder: (context, cycle, _) {
        final now = DateTime.now();
        final cycleDay = cycle.cycleDayFor(now);
        final progress = cycle.cycleProgressFor(now);
        final startDate = cycle.currentCycle?.startDate ?? now;
        final nextDate = cycle.nextPeriodDate();

        final daysUntil =
            nextDate.difference(DateTime(now.year, now.month, now.day)).inDays;

        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              expandedHeight: 104,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text('Period Tracker',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'CURRENT CYCLE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.ai.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'OVULATION',
                                    style: TextStyle(
                                      color: AppColors.ai,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: CycleProgressRing(
                                  day: cycleDay, progress: progress),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Approx. ${daysUntil < 0 ? 0 : daysUntil} days until next period',
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Cycle started: ${DateFormat.yMMMd().format(startDate)}',
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 12),
                            ),
                            Text(
                              'Estimated next: ${DateFormat.yMMMd().format(nextDate)}',
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            PrimaryButton(
                              label: 'Log Period Start',
                              icon: Icons.add,
                              onPressed: () async {
                                await cycle.logPeriodStart(DateTime.now());
                                if (!context.mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Period start logged for today.')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Predictions',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    PredictionCard(
                      title: 'Next Period',
                      value: DateFormat.yMMMd().format(cycle.nextPeriodDate()),
                      color: AppColors.calendar,
                      icon: Icons.event,
                    ),
                    PredictionCard(
                      title: 'Fertile Window',
                      value:
                          '${DateFormat.MMMd().format(cycle.fertileStart())} - '
                          '${DateFormat.MMMd().format(cycle.fertileEnd())}',
                      color: AppColors.fertility,
                      icon: Icons.favorite,
                    ),
                    PredictionCard(
                      title: 'Ovulation Day',
                      value: DateFormat.yMMMd().format(cycle.ovulationDate()),
                      color: AppColors.ai,
                      icon: Icons.brightness_5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
