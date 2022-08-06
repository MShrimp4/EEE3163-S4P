----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/07/13 16:15:20
-- Design Name: 
-- Module Name: adr_reg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adr_reg is
  Port (
	clk : in std_logic; 
	m_in : in std_logic_vector ( 3 downto 0); 
	Load : in std_logic; 
	m_out : out std_logic_vector ( 3 downto 0)
  );
end adr_reg;

architecture Behavioral of adr_reg is

signal num : std_logic_vector (3 downto 0); 

begin

process(clk)
begin 
if rising_edge(clk) then 
	if load = '1' then
	num <= m_in; 
	else num <= num+1;  
	end if; 
end if; 
end process; 

m_out <= num; 

end Behavioral;
