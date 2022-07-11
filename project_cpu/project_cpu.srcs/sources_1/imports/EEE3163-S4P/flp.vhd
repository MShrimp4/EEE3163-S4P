----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/06/27 10:45:50
-- Design Name: 
-- Module Name: Reg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flp is
  Port ( 
  clk : in std_logic; 
  en : in std_logic:='0'; 
  r_in : in std_logic; 
  r_out : out std_logic -- 그냥 출력
  
  );
end flp;

architecture Behavioral of flp is

signal r : std_logic;  

begin

	process(clk)
	begin
	if rising_edge(clk) then 
	if en= '1' then  
		r <= r_in; 
		
	end if; 
	
	r_out <= r; 
	end if; 
	end process; 
	
end Behavioral;
