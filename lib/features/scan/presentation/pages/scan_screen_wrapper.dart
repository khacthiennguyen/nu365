import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/scan/logic/scan_bloc.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/presentation/pages/scan_results_screen.dart';
import 'package:nu365/features/scan/presentation/pages/scan_screen.dart';

class ScanScreenWrapper extends StatefulWidget {
  const ScanScreenWrapper({super.key});

  @override
  State<ScanScreenWrapper> createState() => _ScanScreenWrapperState();
}

class _ScanScreenWrapperState extends State<ScanScreenWrapper> {
  // Tạo Bloc ở cấp cao nhất
  late final ScanBloc _scanBloc;

  @override
  void initState() {
    super.initState();
    _scanBloc = ScanBloc();
  }

  @override
  void dispose() {
    _scanBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng BlocProvider thay vì BlocProvider.value để đảm bảo Bloc được cung cấp đúng cách
    return BlocProvider<ScanBloc>(
      create: (context) => _scanBloc,
      child: BlocListener<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanSuccess && state.prediction.isNotEmpty) {
             print("state.prediction.length: ${state.prediction.length}");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: _scanBloc,
                  child: ScanResultsScreen(
                    imageFile: state.imageFile,
                    predictions: state.prediction,
                  ),
                ),
              ),
            );
          }
     
         
          if (state is ScanSuccess && state.prediction.isEmpty) {
           
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot detect anything in this image'),
              ),
            );
          }
          if (state is ScanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message ?? "Unknown error"}'),
              ),
            );
          }
        },
        child: const ScanScreen(),
      ),
    );
  }
}