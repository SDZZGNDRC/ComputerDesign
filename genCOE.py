import sys

def generate_coe_from_objdump(objdump_output, coe_filename):
    machine_code = []
    lines = objdump_output.split("\n")
    lines = [line.strip() for line in lines if line.strip()]

    for line in lines[3:]:
        parts = line.split("\t")
        if len(parts) > 1:
            opcode = parts[1].strip()
            machine_code.append(opcode)

    # 生成COE文件
    with open(coe_filename, "w") as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        for i, opcode in enumerate(machine_code):
            f.write(opcode)
            if i != len(machine_code) - 1:
                f.write(',\n')
        f.write(";\n")


# 从标准输入读取 objdump 的输出
objdump_output = sys.stdin.read()

# 获取 COE 文件名作为命令行参数
coe_filename_text = sys.argv[1]
coe_filename_data = sys.argv[2]

# 调用函数生成 COE 文件
generate_coe_from_objdump(objdump_output, coe_filename_text)
