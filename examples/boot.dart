import 'package:tbs/tbs_api.dart';

void main() {
  TBS.Ah(0x0E);
  TBS.Al("H");
  TBS.Print();

  TBS.Al("I");
  TBS.Print();

  TBS.Halt();
}
