import sys

OPCODES = {
    "ADD":  0x0,
    "SUB":  0x1,
    "AND":  0x2,
    "OR":   0x3,
    "XOR":  0x4,
    "ADDI": 0x5,
    "LD":   0x6,
    "ST":   0x7,
    "BEQ":  0x8,
    "BNE":  0x9,
    "JMP":  0xA,
    "HALT": 0xF,
}

def reg_num(token):
    token = token.strip().upper()
    if not token.startswith("R"):
        raise ValueError(f"Invalid register: {token}")
    n = int(token[1:])
    if n < 0 or n > 7:
        raise ValueError(f"Register out of range: {token}")
    return n

def parse_imm(token, bits):
    val = int(token, 0)
    lo = -(1 << (bits - 1))
    hi = (1 << bits) - 1
    if bits == 8:
        if val < 0 or val > 0xFF:
            raise ValueError(f"8-bit value out of range: {token}")
        return val & 0xFF
    if val < lo or val > ((1 << (bits - 1)) - 1):
        raise ValueError(f"Signed {bits}-bit immediate out of range: {token}")
    return val & ((1 << bits) - 1)

def strip_comment(line):
    return line.split("#")[0].split("//")[0].strip()

def first_pass(lines):
    labels = {}
    pc = 0
    for raw in lines:
        line = strip_comment(raw)
        if not line:
            continue
        if ":" in line:
            label, rest = line.split(":", 1)
            labels[label.strip()] = pc
            line = rest.strip()
            if not line:
                continue
        pc += 1
    return labels

def encode(line, labels, pc):
    parts = line.replace(",", " ").split()
    if not parts:
        return None

    op = parts[0].upper()

    if op == "HALT":
        return 0xF000

    if op in ["ADD", "SUB", "AND", "OR", "XOR"]:
        rd = reg_num(parts[1])
        rs = reg_num(parts[2])
        rt = reg_num(parts[3])
        return (OPCODES[op] << 12) | (rd << 9) | (rs << 6) | (rt << 3)

    if op == "ADDI":
        rd = reg_num(parts[1])
        rs = reg_num(parts[2])
        imm6 = parse_imm(parts[3], 6)
        return (OPCODES[op] << 12) | (rd << 9) | (rs << 6) | imm6

    if op == "LD":
        rd = reg_num(parts[1])
        addr8 = parse_imm(parts[2], 8)
        return (OPCODES[op] << 12) | (rd << 9) | addr8

    if op == "ST":
        rs = reg_num(parts[1])
        addr8 = parse_imm(parts[2], 8)
        return (OPCODES[op] << 12) | (rs << 9) | addr8

    if op in ["BEQ", "BNE"]:
        rs = reg_num(parts[1])
        rt = reg_num(parts[2])
        target = parts[3]
        if target in labels:
            offset = labels[target] - (pc + 1)
        else:
            offset = int(target, 0)
        off6 = parse_imm(str(offset), 6)
        return (OPCODES[op] << 12) | (rs << 9) | (rt << 6) | off6

    if op == "JMP":
        target = parts[1]
        addr = labels[target] if target in labels else int(target, 0)
        if addr < 0 or addr > 0xFFF:
            raise ValueError(f"Jump target out of range: {target}")
        return (OPCODES[op] << 12) | addr

    raise ValueError(f"Unknown instruction: {op}")

def assemble_file(infile, outfile):
    with open(infile, "r") as f:
        lines = f.readlines()

    labels = first_pass(lines)

    out = []
    pc = 0
    for raw in lines:
        line = strip_comment(raw)
        if not line:
            continue
        if ":" in line:
            _, line = line.split(":", 1)
            line = line.strip()
            if not line:
                continue
        word = encode(line, labels, pc)
        if word is not None:
            out.append(f"{word:04X}")
            pc += 1

    with open(outfile, "w") as f:
        for word in out:
            f.write(word + "\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python assembler.py program.asm program.hex")
        sys.exit(1)

    assemble_file(sys.argv[1], sys.argv[2])
    print(f"Assembled {sys.argv[1]} -> {sys.argv[2]}")