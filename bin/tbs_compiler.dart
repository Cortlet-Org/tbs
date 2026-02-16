import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    print("Usage: dart run tbs <path-to-boot.dart>");
    exit(1);
  }

  final inputPath = args[0];
  final file = File(inputPath);

  if (!await file.exists()) {
    print("File not found: $inputPath");
    exit(1);
  }

  final code = await file.readAsString();

  final asm = StringBuffer()
    ..writeln("BITS 16")
    ..writeln("org 0x7C00");

  // --- REAL WORKING COMPILER ---
  for (final rawLine in code.split('\n')) {
    final line = rawLine.trim();

    // TBS.Ah(x)
    if (line.startsWith("TBS.Ah(")) {
      final value = line.substring(7, line.length - 2).trim();
      asm.writeln("mov ah, $value");
    }

    // TBS.Al("H") OR TBS.Al(65)
    if (line.startsWith("TBS.Al(")) {
      var value = line.substring(7, line.length - 2).trim();

      // If it's a string, turn into NASM char literal: 'H'
      if (value.startsWith('"') && value.endsWith('"')) {
        final char = value.substring(1, value.length - 1);
        value = "'$char'";
      }

      asm.writeln("mov al, $value");
    }

    // TBS.Print()
    if (line.startsWith("TBS.Print()")) {
      asm.writeln("mov ah, 0x0E");
      asm.writeln("int 0x10");
    }

    // TBS.Halt()
    if (line.startsWith("TBS.Halt()")) {
      asm.writeln("hlt");
    }
  }

  // Boot sector signature (must be last)
  asm.writeln(r"times 510 - ($ - $$) db 0");
  asm.writeln(r"dw 0xAA55");

  // Save boot.asm
  final asmOut = File("boot.asm");
  await asmOut.writeAsString(asm.toString());
  print("✓ Generated boot.asm");

  // Build boot.bin using NASM
  final nasm = await Process.run(
    "nasm",
    ["-f", "bin", "boot.asm", "-o", "boot.bin"],
  );

  if (nasm.stderr.toString().isNotEmpty) {
    print("NASM Error:");
    print(nasm.stderr);
    exit(1);
  }

  print("✓ boot.bin created");
}
