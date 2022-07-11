----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/06/29 23:43:10
-- Design Name: 
-- Module Name: buf - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity buf is 
   PORT ( 
      Buffer_en : in std_logic;
      
      Data_out : in std_logic_vector(3 downto 0); 
      Data_inout : inout std_logic_vector(3 downto 0)
      );
end buf;
      
      
architecture Behavioral of buf is
begin
   
   Data_inout <= Data_out when Buffer_en = '0'
      else (others => 'Z'); 
         
end Behavioral;