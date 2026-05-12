import 'package:altahris_mobile/features/visit_plan/presentation/widgets/visit_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';
import 'package:altahris_mobile/features/visit_plan/presentation/bloc/visit_plan_bloc.dart';
import 'package:altahris_mobile/features/visit_plan/presentation/bloc/visit_plan_event.dart';
import 'package:altahris_mobile/features/visit_plan/presentation/bloc/visit_plan_state.dart';
import 'package:altahris_mobile/features/visit_plan/presentation/pages/create_visit_plan_page.dart';

class VisitPlanPage extends StatefulWidget {
  const VisitPlanPage({super.key});

  @override
  State<VisitPlanPage> createState() => _VisitPlanPageState();
}

class _VisitPlanPageState extends State<VisitPlanPage> {
  // TODO: Get real employee ID
  final String _employeeId = 'EMP123';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VisitPlanBloc>(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              'Visit Plans',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: BlocBuilder<VisitPlanBloc, VisitPlanState>(
            builder: (context, state) {
              if (state is VisitPlanLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VisitPlansLoaded) {
                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<VisitPlanBloc>()
                      .add(FetchVisitPlansEvent(_employeeId)),
                  child: state.visitPlans.isEmpty
                      ? const Center(child: Text('No visit plans found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.visitPlans.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: VisitPlanCard(
                                visitPlan: state.visitPlans[index],
                              ),
                            );
                          },
                        ),
                );
              } else if (state is VisitPlanFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () => context
                            .read<VisitPlanBloc>()
                            .add(FetchVisitPlansEvent(_employeeId)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          bottomNavigationBar: _buildBottomButton(context),
        ),
      ),
    );
  }

  void _fetchVisitPlans() {
    // We cannot call context.read here because it's not available until built
  }
  
  @override
  void initState() {
    super.initState();
    // Move fetching to the BLoC initialization if possible or use a post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
       context.read<VisitPlanBloc>().add(FetchVisitPlansEvent(_employeeId));
    });
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<VisitPlanBloc>(),
              child: const CreateVisitPlanPage(),
            ),
          ));
        },
        child: const Text('Create New Visit Plan',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
