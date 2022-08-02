----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/07/29 10:51:16
-- Design Name: 
-- Module Name: counter - Behavioral
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

entity counter is
  Port (
	input : in std_logic_vector ( 5 downto 0); 
	m_out : out std_logic_vector ( 5 downto 0); 
	Load : in std_logic; 
	inc : in std_logic;
	m_clk : in std_logic
  );
end counter;

architecture Behavioral of counter is 
signal val : std_logic_vector( 5 downto 0) := (others=>'0'); 
signal clk : std_logic; 


begin

clk <= m_clk;
  
process(clk) 
 begin
	if rising_edge(clk) then 
		if Load = '0' then 
		val <= val + 1 ; 
		else 
		val <= input; 
		end if; 
		
	end if; 
	
end process; 
m_out <= val; 

end Behavioral;
