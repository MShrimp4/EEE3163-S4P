#!/bin/python

import csv
import re

from rom_ram import *

template = r"""

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity {ROM_NAME} is
PORT ({IO_LIST});
end entity {ROM_NAME};

architecture Behavioral of {ROM_NAME} is
{SIGNAL_LIST}
begin
{ASSIGN_LIST}
end Behavioral;

"""


addr_name = "addr"
state_len   = 0
signal_dict = dict()
symbol_dict = {"X":0, "clear":1, "ADD":2, "SUB":3}

with open ("rom.csv", encoding="UTF-8") as file:
    csvreader = csv.reader(file)
    for row in csvreader:
        if row[0] == "":
            continue
        if row[0] == "Address[]":
            continue

        try:
            temp = [symbol_dict[x] if x in symbol_dict else int(x,16) for x in row[1:]]
            temp.reverse()
            signal_dict[row[0]] = temp
        except:
            symbol_dict |= {x:i for i,x in enumerate(row[1:])}
            state_len = len(row[1:])
    #print(signal_dict)
    #print(symbol_dict)

rom_dict = dict()
sig_len_dict = dict()
for key, val in signal_dict.items():
    #print (key)
    m = re.match(r"(\w+)\[(\d*)\]", key)
    if m is not None:
        name  = m.group(1)
        index = m.group(2)
        if index == "":
            size = minimum_len (max(val))
            lst = [tobit(x, size) for x in val]
            for i in range(size):
                msb_i = size - 1 - i
                rom_dict[rom_name(name,msb_i)] = "".join([x[i] for x in lst])
            sig_len_dict[name] = size
        else:
            rom_dict[rom_name(name,int(index))] = lst_to_bitstr(val)
            sig_len_dict[name] = max([int(index) + 1, sig_len_dict.get(name,0)])
    else:
        name = key
        rom_dict[rom_name(name,0)] = lst_to_bitstr(val)
        sig_len_dict[name] = 1

#rom_dict = dict(sorted(rom_dict.items()))
#print (rom_dict)
#print (sig_len_dict)

sig_list = "\n".join([gen_rom_define(name,data,state_len) for name,data in rom_dict.items()])
io_list = "; \n".join([define_io (addr_name,True,minimum_len(state_len-1))] + [define_io (name, False, length) for name, length in sig_len_dict.items()])
as_list = "\n".join([gen_code_lookup(addr_name, name, length) for name, length in sig_len_dict.items()])
print(template.format(ROM_NAME = "uop_rom", IO_LIST = io_list, SIGNAL_LIST = sig_list, ASSIGN_LIST = as_list))

name = ""
map_list = list()
with open("map.csv", encoding="UTF-8") as file:
    csvreader = csv.reader(file)
    for row in csvreader:
        if row[0] == "":
            continue
        if row[0] == "Address[]":
            continue

        print(row)
        name = row[0]
        temp = [symbol_dict[x] for x in row[1:]]
        temp.reverse()
        map_list = temp
        break

rom_dict = dict()
sig_len_dict = dict()
size = minimum_len(state_len-1)
state_len = len(map_list)
lst = [tobit(x, size) for x in map_list]
for i in range(size):
    msb_i = size - 1 - i
    rom_dict[rom_name(name,msb_i)] = "".join([x[i] for x in lst])
sig_len_dict[name] = size
        

map_len = len(map_list)


sig_list = "\n".join([gen_rom_define(name,data,state_len) for name,data in rom_dict.items()])
io_list = "; \n".join([define_io (addr_name,True,minimum_len(state_len-1))] + [define_io (name, False, length) for name, length in sig_len_dict.items()])
as_list = "\n".join([gen_code_lookup(addr_name, name, length) for name, length in sig_len_dict.items()])
print(template.format(ROM_NAME = "map_rom", IO_LIST = io_list, SIGNAL_LIST = sig_list, ASSIGN_LIST = as_list))
