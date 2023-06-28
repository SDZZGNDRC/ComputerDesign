import sys
import subprocess


def generate_coe_from_objdump_data(objdump_output, coe_filename):
    data = []
    lines = objdump_output.split("\n")
    lines = [line.strip() for line in lines if line.strip()]

    for line in lines[3:]:
        parts = line.split("\t")
        if len(parts) > 1:
            value = parts[1].strip().split()[0]
            data.append(value)

    # 生成 COE 文件
    with open(coe_filename, "w") as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        for i, value in enumerate(data):
            f.write(value)
            if i != len(data) - 1:
                f.write(',\n')
        f.write(";\n")



def generate_coe_from_objdump_text(objdump_output, coe_filename):
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

if __name__ == '__main__':
    asm_filename = sys.argv[1]
    coe_filename_text = sys.argv[2]
    coe_filename_data = sys.argv[3]
    
    output_filename = asm_filename.replace(".s", ".o")
    output_filename = asm_filename.replace(".S", ".o")
    
    # 生成.o文件
    command = f"mips-linux-gnu-as -o {output_filename} {asm_filename}"
    output = subprocess.check_output(command, shell=True)
    print(output.decode())
    
    # 生成text段的coe文件
    command = f"mips-linux-gnu-objdump -d  {output_filename}"
    output = subprocess.check_output(command, shell=True)
    generate_coe_from_objdump_text(output.decode(), coe_filename_text)
    
    # 生成data段的coe文件
    command = f"mips-linux-gnu-objdump -d -j .data {output_filename}"
    output = subprocess.check_output(command, shell=True)

    # 调用函数生成 COE 文件
    generate_coe_from_objdump_data(output.decode(), coe_filename_data)

