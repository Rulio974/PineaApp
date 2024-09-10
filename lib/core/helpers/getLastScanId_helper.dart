import 'package:pineapp/models/recon/recon.dart';
import 'package:pineapp/core/services/api/api_service.dart';

Future<int> getLastScanId(ApiService _apiService) async {
  try {
    final List<ReconScan> response = await _apiService.getReconScans();

    if (response.isNotEmpty) {
      return response.last.scan_id;
    }
  } catch (e) {
    print('Erreur lors de la récupération des scans : $e');
  }
  return -1;
}
