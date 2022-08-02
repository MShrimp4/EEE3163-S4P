----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/07/29 10:15:42
-- Design Name: 
-- Module Name: mux_6 - Behavioral
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

entity mux_6 is
  Port (
    m_in_0 : in std_logic_vector(5 downto 0); 
	m_in_1 : in std_logic_vector(5 downto 0); 
	sel : in std_logic; 
	m_out : out std_logic_vector(5 downto 0)
  );
end mux_6;

architecture Behavioral of mux_6 is

begin
	with sel select m_out 
	<= m_in_0 when '0',
		m_in_1 when '1',
		m_in_0 when others; 

end Behavioral;
