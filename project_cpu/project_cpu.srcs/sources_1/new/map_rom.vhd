----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/08/02 14:16:13
-- Design Name: 
-- Module Name: map_rom - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity map_rom is
PORT (
addr : in STD_LOGIC_VECTOR (3 downto 0); 
MIR : out STD_LOGIC_VECTOR (5 downto 0));
end entity map_rom;

architecture Behavioral of map_rom is
    signal rom_MIR_5 : STD_LOGIC_VECTOR (15 downto 0) := "1000110000000000";
    signal rom_MIR_4 : STD_LOGIC_VECTOR (15 downto 0) := "1111001100000000";
    signal rom_MIR_3 : STD_LOGIC_VECTOR (15 downto 0) := "0111110000111110";
    signal rom_MIR_2 : STD_LOGIC_VECTOR (15 downto 0) := "0110101000100001";
    signal rom_MIR_1 : STD_LOGIC_VECTOR (15 downto 0) := "0111001100111001";
    signal rom_MIR_0 : STD_LOGIC_VECTOR (15 downto 0) := "1101011100110101";
begin
    MIR <= rom_MIR_5(to_integer(unsigned(addr))) & rom_MIR_4(to_integer(unsigned(addr))) & rom_MIR_3(to_integer(unsigned(addr))) & rom_MIR_2(to_integer(unsigned(addr))) & rom_MIR_1(to_integer(unsigned(addr))) & rom_MIR_0(to_integer(unsigned(addr)));
end Behavioral;
