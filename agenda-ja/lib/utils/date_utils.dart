import 'package:intl/intl.dart';

String formatarData(DateTime dt) =>
    DateFormat('dd/MM/yyyy').format(dt.toLocal());

String formatarHora(DateTime dt) => DateFormat('HH:mm').format(dt.toLocal());

String formatarDataIso(DateTime dt) =>
    DateFormat('yyyy-MM-dd').format(dt.toLocal());

String statusLabel(String status) {
  switch (status) {
    case 'pendente':
      return 'Pendente';
    case 'confirmado':
      return 'Confirmado';
    case 'cancelado':
      return 'Cancelado';
    default:
      return status;
  }
}
