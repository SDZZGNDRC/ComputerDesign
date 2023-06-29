'''
接受asm汇编源文件, 生成对应的vivado coe初始化文件
'''

from typing import Callable, List, Dict
import sys

def convert_addi(inst: str) -> str:
    # 删除#开始的注释部分
    inst = inst.split('#')[0]
    params = [ i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'addi':
        raise Exception(f'Invalid instruction: {params}')
    rd = params[1].strip()
    rs = params[2].strip()
    immediate = int(params[3].strip(), 0)
    
    # 构建机器码
    opcode = '001000'  # addi指令的操作码
    rs_bin = '{:05b}'.format(int(rs[1:]))  # 将rs寄存器编号转换为5位的二进制数
    rd_bin = '{:05b}'.format(int(rd[1:]))  # 将rd寄存器编号转换为5位的二进制数
    immediate_bin = '{:016b}'.format(immediate & 0xFFFF)  # 将立即数转换为16位的二进制数
    
    machine_code = opcode + rs_bin + rd_bin + immediate_bin
    # 转换为16进制数
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_add(inst: str) -> str:
    # 删除#开始的注释部分
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'add':
        raise Exception(f'Invalid instruction: {params}')
    rd = params[1].strip()
    rs = params[2].strip()
    rt = params[3].strip()
    
    # Construct the machine code
    opcode = '000000'  # add instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    rd_bin = '{:05b}'.format(int(rd[1:]))  # Convert rd register number to a 5-bit binary
    shamt_bin = '00000'  # For add instruction, shamt is always 0
    funct = '100000'  # add instruction's funct field
    
    machine_code = opcode + rs_bin + rt_bin + rd_bin + shamt_bin + funct
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_sub(inst: str) -> str:
    # Remove comments starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'sub':
        raise Exception(f'Invalid instruction: {params}')
    rd = params[1].strip()
    rs = params[2].strip()
    rt = params[3].strip()

    # Construct the machine code
    opcode = '000000'  # sub instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    rd_bin = '{:05b}'.format(int(rd[1:]))  # Convert rd register number to a 5-bit binary
    shamt_bin = '00000'  # For sub instruction, shamt is always 0
    funct = '100010'  # sub instruction's funct field

    machine_code = opcode + rs_bin + rt_bin + rd_bin + shamt_bin + funct
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)

    return hex_code

def convert_or(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'or':
        raise Exception(f'Invalid instruction: {params}')
    rd = params[1].strip()
    rs = params[2].strip()
    rt = params[3].strip()
    
    # Construct the machine code
    opcode = '000000'  # or instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    rd_bin = '{:05b}'.format(int(rd[1:]))  # Convert rd register number to a 5-bit binary
    shamt_bin = '00000'  # For or instruction, shamt is always 0
    funct = '100101'  # or instruction's funct field
    
    machine_code = opcode + rs_bin + rt_bin + rd_bin + shamt_bin + funct
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_and(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'and':
        raise Exception(f'Invalid instruction: {params}')
    rd = params[1].strip()
    rs = params[2].strip()
    rt = params[3].strip()
    
    # Construct the machine code
    opcode = '000000'  # and instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    rd_bin = '{:05b}'.format(int(rd[1:]))  # Convert rd register number to a 5-bit binary
    shamt_bin = '00000'  # For and instruction, shamt is always 0
    funct = '100100'  # and instruction's funct field
    
    machine_code = opcode + rs_bin + rt_bin + rd_bin + shamt_bin + funct
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_slt(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'slt':
        raise Exception(f'Invalid instruction: {params}')
    rd = params[1].strip()
    rs = params[2].strip()
    rt = params[3].strip()
    
    # Construct the machine code
    opcode = '000000'  # slt instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    rd_bin = '{:05b}'.format(int(rd[1:]))  # Convert rd register number to a 5-bit binary
    shamt_bin = '00000'  # For slt instruction, shamt is always 0
    funct = '101010'  # slt instruction's funct field
    
    machine_code = opcode + rs_bin + rt_bin + rd_bin + shamt_bin + funct
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_beq(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'beq':
        raise Exception(f'Invalid instruction: {params}')
    rs = params[1].strip()
    rt = params[2].strip()
    offset = params[3].strip()
    print(f'convert_beq: rs->{rs} rt->{rt} offset->{offset}')
    
    
    # Construct the machine code
    opcode = '000100'  # beq instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    offset_bin = '{:016b}'.format(int(offset, 0))  # Convert offset to a 16-bit binary
    
    machine_code = opcode + rs_bin + rt_bin + offset_bin
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_bne(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 4 or params[0] != 'bne':
        raise Exception(f'Invalid instruction: {params}')
    rs = params[1].strip()
    rt = params[2].strip()
    offset = params[3].strip()
    print(f'convert_bne: rs->{rs} rt->{rt} offset->{offset}')
    
    
    # Construct the machine code
    opcode = '000101'  # bne instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    offset_bin = '{:016b}'.format(int(offset, 0))  # Convert offset to a 16-bit binary
    
    machine_code = opcode + rs_bin + rt_bin + offset_bin
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_sb(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 3 or params[0] != 'sb':
        raise Exception(f'Invalid instruction: {params}')
    rt = params[1].strip()
    offset = params[2].strip().split('(')[0].strip()
    rs = params[2].strip().split('(')[1].strip(')')
    
    # Construct the machine code
    opcode = '101000'  # sb instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    offset_bin = '{:016b}'.format(int(offset, 0))  # Convert offset to a 16-bit binary
    
    machine_code = opcode + rs_bin + rt_bin + offset_bin
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_lb(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 3 or params[0] != 'lb':
        raise Exception(f'Invalid instruction: {params}')
    rt = params[1].strip()
    offset = params[2].strip().split('(')[0].strip()
    rs = params[2].strip().split('(')[1].strip(')')
    
    # Construct the machine code
    opcode = '100000'  # lb instruction's opcode
    rs_bin = '{:05b}'.format(int(rs[1:]))  # Convert rs register number to a 5-bit binary
    rt_bin = '{:05b}'.format(int(rt[1:]))  # Convert rt register number to a 5-bit binary
    offset_bin = '{:016b}'.format(int(offset, 0))  # Convert offset to a 16-bit binary
    
    machine_code = opcode + rs_bin + rt_bin + offset_bin
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def convert_j(inst: str) -> str:
    # Delete the commented portion starting with '#'
    inst = inst.split('#')[0]
    params = [i.strip(',') for i in inst.split(' ') if i.strip(',')]
    if len(params) != 2 or params[0] != 'j':
        raise Exception(f'Invalid instruction: {params}')
    target = params[1].strip()
    print(f'convert_j: target->{target}')
    
    # Construct the machine code
    opcode = '000010'  # j instruction's opcode
    
    machine_code = opcode + target
    # Convert to hexadecimal
    hex_code = hex(int(machine_code, 2))[2:].zfill(8)
    
    return hex_code

def get_ConvertFunc(inst: str) -> Callable[[str], str]:
        if 'addi' in inst:
            return convert_addi
        elif 'add' in inst:
            return convert_add
        elif 'sub' in inst:
            return convert_sub
        elif 'or' in inst:
            return convert_or
        elif 'and' in inst:
            return convert_and
        elif 'slt' in inst:
            return convert_slt
        elif 'beq' in inst:
            return convert_beq
        elif 'bne' in inst:
            return convert_bne
        elif 'sb' in inst:
            return convert_sb
        elif 'lb' in inst:
            return convert_lb
        elif 'j' in inst:
            return convert_j
        else:
            raise Exception(f'Invalid instruction: {inst}')

def is_label(inst: str) -> bool:
    '''Check if the instruction is a label'''
    if inst.strip().endswith(':'):
        return True

def is_inst(inst: str) -> bool:
    '''Check if the instruction is a valid instruction'''
    try:
        get_ConvertFunc(inst)
        return True
    except Exception:
        return False

def is_data_define(line: str) -> bool:
    '''判断该行是否为变量定义 (待完善)'''
    params = line.split(' ')
    if len(params) == 3 and ':' in params[0]:
        return True
    else:
        return False

def int_to_hex(num: int, length: int) -> str:
    # 将整数转换为指定长度的十六进制有符号补码字符串
    hex_str = format(num & (2 ** length - 1), f'0{length}x')
    return hex_str

def replace_label(inst: str, label_table: Dict[str, int], pc_next: int) -> str:
    # 替换Label, 从长到短
    inst_type = inst.split()[0]
    new_inst = inst
    if inst_type == 'beq' or inst_type == 'bne':
        for label in sorted(label_table.keys(), key=lambda x: len(x), reverse=True):
            if label in inst:
                offset = (label_table[label] - pc_next) >> 2
                offset_binary = offset & 0xFFFF  # 保留16位
                offset_hex = hex(offset_binary & 0xFFFF) # 转为十六进制形式，补齐4位
                new_inst = inst.replace(label, offset_hex)
                break
    elif inst_type == 'j':
        for label in sorted(label_table.keys(), key=lambda x: len(x), reverse=True):
            if label in inst:
                target_pc = bin(label_table[label])[2:].zfill(32)
                target = target_pc[4:30]
                new_inst = inst.replace(label, target)
                break
    return new_inst

def scan_table(label_inst: List[str]) -> Dict[str, int]:
    '''搜索label并建立label表'''
    label_table = {}
    pc = 0
    for line in label_inst:
        if is_label(line):
            label = line.split(':')[0].strip()
            # 判断该label是否已经存在
            if label in label_table:
                raise Exception(f'Duplicate label: {label}')
            label_table[label] = pc
        elif is_inst(line):
            pc += 4
    return label_table

def asm(asm_content: str) -> List[str]:
    # 删除空行和注释
    asm_inst = [i.strip() for i in asm_content.split('\n') if i.strip()]
    asm_inst = [i.split('#')[0].strip() for i in asm_inst if i.split('#')[0].strip()]
    
    # 删除 .data段
    new_asm_inst = []
    text_sect_start = False
    text_sect_end = False
    for i in asm_inst:
        if text_sect_end:
            break
        if '.text' in i: # .text段开始
            text_sect_start = True
        if '.data' in i and text_sect_start: # .text段提前结束
            text_sect_end = True
        if text_sect_start:
            new_asm_inst.append(i)
    asm_inst = new_asm_inst

    # 进一步过滤        
    asm_inst = [i for i in asm_inst if is_inst(i) or is_label(i)]

    
    print(f'asm_inst={asm_inst}')
    label_table = scan_table(asm_inst)
    machine_code = []
    pc = 0
    for code in asm_inst:
        if is_inst(code):
            # 替换Label, 从长到短
            # print(f'before: {code}')
            code = replace_label(code, label_table, pc+4)
            # print(f'after: {code}')
            # 转换指令
            machine_code.append(get_ConvertFunc(code)(code))
            
            pc += 4
            
    return machine_code

def asm_to_text_coe(machine_codes: List[str], coe_file: str):
    with open(coe_file, 'w', encoding='utf-8') as fout:
        fout.write('memory_initialization_radix=16;\n')
        fout.write('memory_initialization_vector=\n')
        for i, code in enumerate(machine_codes):
            if i == len(machine_codes) - 1:
                fout.write(f'{code};\n')
            else:
                fout.write(f'{code},\n')

def asm_to_data_coe(asm_content: str, coe_file: str):
    '''从汇编文件中搜索.data段, 并生成数据存储器的coe文件'''
    asm_lines = [i.strip() for i in asm_content.split('\n') if i.strip()]
    asm_lines = [i.split('#')[0].strip() for i in asm_lines if i.split('#')[0].strip()]
    data_sect_start = False
    data_sect_end = False
    defined_data_array = []
    for line in asm_lines:
        if data_sect_end:
            break
        if '.data' in line: # 数据段开始
            data_sect_start = True
        if '.text' in line and data_sect_start: # data段提前结束
            data_sect_end = True
        if is_data_define(line):
            params = line.split(' ')
            defined_data = params[-1][2:].zfill(8)
            defined_data_array.append(defined_data)
    
    if len(defined_data_array) == 0:
        print('WARNING: Can not find .data section, Failed to generate data_coe file')
        return
    
    with open(coe_file, 'w', encoding='utf-8') as fout:
        fout.write('memory_initialization_radix=16;\n')
        fout.write('memory_initialization_vector=\n')
        for i, code in enumerate(defined_data_array):
            if i == len(defined_data_array) - 1:
                fout.write(f'{code};\n')
            else:
                fout.write(f'{code},\n')

if __name__ == '__main__':
    asm_file = sys.argv[1]
    text_coe_file = sys.argv[2]

    asm_content = ''
    with open(asm_file, 'r', encoding='utf-8') as fin:
        asm_content = fin.read()
    machine_codes = asm(asm_content)
    for i, inst in enumerate(machine_codes):
        print(f'{hex(i*4)}:\t{inst}')
    
    asm_to_text_coe(machine_codes, text_coe_file)

    if len(sys.argv) >= 4: # 需要生成data_coe文件
        data_coe_file = sys.argv[3]
        asm_to_data_coe(asm_content, data_coe_file)