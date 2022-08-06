----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/08/01 16:07:37
-- Design Name: 
-- Module Name: mux1_8 - Behavioral
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

entity mux1_8 is
  Port ( 
  m_in : in std_logic_vector ( 7 downto 0); 
  sel : in std_logic_vector (2 downto 0); 
  m_out : out std_logic
  );
end mux1_8;

architecture Behavioral of mux1_8 is

begin
	m_out <= m_in(0) when sel = "000" 
	    else m_in(1) when sel = "001"
		else m_in(2) when sel = "010"
		else m_in(3);
		

end Behavioral;
