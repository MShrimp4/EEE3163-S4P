#!/bin/python

import math



def tobit (num, size):
    return format(num, "0%db"%size)

def lst_to_bitstr (lst):
    for e in lst:
        if e == 0 or e == 1:
            continue
        else:
            raise Exception("The bit is neither 0 nor 1 : %s"%e)
    return "".join([str(x) for x in lst])

def minimum_len (size):
    return int(math.ceil(math.log2(size+1)))

def define_io (signal, is_input, length):
    io = "in" if is_input else "out"
    data_type = "STD_LOGIC" if length == 1 else "STD_LOGIC_VECTOR ({} downto {})".format(length-1,0)
    return "{signal} : {IO} {TYPE}".format(signal = signal, IO = io, TYPE = data_type)

def rom_name (signal, index):
    return "rom_{signal}_{index}".format(signal = signal, index = index)

def gen_rom_define (sig, data, length):
    data_type = "STD_LOGIC" if length == 1 else "STD_LOGIC_VECTOR ({} downto {})".format(length-1,0)
    return "    signal {sig} : {TYPE} := \"{DATA}\";".format(sig = sig, TYPE = data_type, DATA = data)

def gen_code_lookup (addr_name, sig, length, out_sig = None):
    out_sig = sig if out_sig is None else out_sig
    return "    {sig} <= ".format(sig = out_sig) + " & ".join(["{rom}(to_integer(unsigned({addr})))".format(rom=rom_name(sig,length-1-i),addr=addr_name) for i in range(length)]) + ";"

def gen_code_assign (addr_name, sig, length):
    lst = []
    for i in range(length):
        rom = rom_name(sig,i)
        lst.append(f"    {rom}(to_integer(unsigned({addr_name}))) <= {sig}({i});")
    return "\n".join(lst)
