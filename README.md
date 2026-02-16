# TBS - Teretalia Boot Set
Teretalia Boot Set is a **dart based compiler** that generates real 16-bit x86 bootloaders.

It provides a minimal DSL implemented in Dart that maps directly to BIOS Interrupts and register operations.

## Features:

- Dart DSL
- `TBS.Al` and `TBS.Ah` supported.
- Only Dart files - no `.tbs` files.
- Compiles to ASM and outputs to .bin (bootable in QEMU and hardware.)

## Example
You can run the following example using:

```
dart run bin/tbs_compiler.dart examples/boot.dart
```

```dart
import 'package:tbs/tbs_api.dart';

void main() {
  TBS.Al("H");
  TBS.Print();

  TBS.Al("I");
  TBS.Print();

  TBS.Halt();
}
```

## Supported Instructions:

| Instruction   | ASM Output                      | 
|---------------|---------------------------------|
| `TBS.Ah(x)`   | `mov ah, x`                     |
| `TBS.Al(x)`   | `mov al, x`                     |
| `TBS.Print()` | `mov ah, 0x0E`, then `int 0x10` |
| `TBS.Halt()`  | `hlt`                           |
