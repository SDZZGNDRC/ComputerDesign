from typing import Callable, List, Dict

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
        if inst:
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

def asm(asm_content: str) -> List[str]:
    asm_inst = [i.strip() for i in asm_content.split('\n') if i.strip()]
    asm_inst = [i.split('#')[0].strip() for i in asm_inst if i.split('#')[0].strip()]
    label_table = {}
    machine_code = []
    pc = 0
    for code in asm_inst:
        if is_label(code):
            label = code.split(':')[0].strip()
            label_table[label] = pc
        elif code:
            # 替换Label, 从长到短
            # print(f'before: {code}')
            code = replace_label(code, label_table, pc+4)
            # print(f'after: {code}')
            # 转换指令
            machine_code.append(get_ConvertFunc(code)(code))
            
            pc += 4
            
    return machine_code

if __name__ == '__main__':
    insts = '''
    addi    $1, $0, 0x64        # 最大循环次数
    addi    $2, $0, 0x0         # 当前循环次数
    addi    $3, $0, 0x1         # 初始值
START:  # 循环开始
    addi    $2, $2, 0x1         # 循环次数加 1
    add     $3, $2, $3          # 累加
    bne     $2, $1, START       # 判断是否达到最大循环次数, 否则继续累加

    # 结束累加
    sb      $3, 0x1000($0)      # 保存结果
EXIT:   # 阻塞停机
    j       EXIT'''
    
    for i, inst in enumerate(asm(insts)):
        print(f'{hex(i*4)}:\t{inst}')