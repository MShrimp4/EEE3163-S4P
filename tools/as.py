import re

## Addr parse
## ("0000", "0001") or ("{H_LABEL}", "{L_LABEL}")

_SRA  = 0
_CLA  = 1
_ADD  = 2
_SUB  = 3
_LDA  = 4
_STA  = 5
_HLT  = 6
#NONE = 7
_MVI = 8
_MOV  = 9
_CMPI = 10
_CMP  = 11
_JC   = 12
_JZ   = 13
_JMP  = 14
_MOVM = 15

def fromhex (num_h):
    num_str = num_h.strip()
    if num_str.endswith(('h', 'H')):
        return int(num_str[:-1],16)
    print (num_str)
    return None

def parse_addr (addr):
    address = fromhex(addr)
    if address == None:
        return ["H_" + addr, "L_" + addr]
    else:
        return [address // 16, address % 16] 

def reg_parse (reg):
    return {"A":0, "B":1, "C":2, "D":3}.get(reg, None)

def SRA (_,__):
    return [_SRA]

def CLA (_,__):
    return [_CLA]

def ADD (_,__):
    return [_ADD]

def SUB (_,__):
    return [_SUB]

def LDA (_,__):
    return [_LDA]

def STA (_,__):
    return [_STA]

def HLT (_,__):
    return [_HLT]

def MVI (_,dt4):
    c = fromhex (dt4)
    return [_MVI, c]

def MOV (arg1, arg2):
    reg1 = reg_parse (arg1)
    reg2 = reg_parse (arg2)
    if reg2 != None:
        reg_word = reg1 * 4 + reg2
        return [_MOV, reg_word]
    else:
        return [_MOVM] + parse_addr(arg2)

def CMP (_, data):
    reg = reg_parse (data)
    if reg != None:
        return [_CMP, reg]
    
    c = hex_parse (constant)
    return [_CMPI, c]

def JC (addr, _):
    return [_JC] + parse_addr(addr)

def JZ (addr, _):
    return [_JZ] + parse_addr(addr)

def JMP (addr, _):
    return [_JMP] + parse_addr(addr)

def DB (dt4, _):
    data = fromhex (dt4)
    if data == None:
        return [0]
    else:
        return [data]

cmds = {"SRA": SRA,
        "CLA": CLA,
        "ADD": ADD,
        "SUB": SUB,
        "LDA": LDA,
        "STA": STA,
        "HLT": HLT,
        "MVI": MVI,
        "MOV": MOV,
        "CMP": CMP,
        "JC" : JC ,
        "JZ" : JZ ,
        "JMP": JMP,
        "DB" : DB
        }
def dispatch (args):
    return cmds.get(args[0], lambda _,__: [_HLT]) (args[1], args[2])
#
#
#

asm_pattern = re.compile (r"(([^\s:]+)\s*:)?\s*(\w{2,4})\s*([^,\s]+)?(\s*,\s*(\w+))?")

with open("asm.txt") as f:
    asm_lst  = []
    sym_dict = dict()
    pc       = 0
    for line in f.readlines():
        match = asm_pattern.search(line)
        if match == None:
            continue
        if match.group(2) != None:
            sym_dict[match.group(2)] = pc
        args = [match.group(3), match.group(4), match.group(6)]

        if args[0] == "ORG":
            pc = fromhex(args[1])
            continue
        new_asm = dispatch (args)
        print ("%d : %s ==> %s" %(pc, str(args), str(new_asm)))
        pc = pc + len(new_asm)
        asm_lst = asm_lst + new_asm
    print (sym_dict)

    word_lst = []
    for word in asm_lst:
        bit = None
        if isinstance (word, int):
            bit = word
        else:
            addr = sym_dict.get(word[2:], None)
            if word[0] == 'H':
                bit = addr // 16
            else:
                bit = addr % 16
        if bit >= 16 or bit < 0:
            raise Exception ("4-bit word type should be in range 0<=x<=15")
        word_lst.append (format(bit, '04b'))
    print(word_lst)

    
