

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux_8 is
  Port (
	m_in_0, m_in_1, m_in_2 : in std_logic_vector(7 downto 0); 
	sel : in std_logic_vector(1 downto 0); 
	m_out : out std_logic_vector ( 7 downto 0)
  );
end mux_8;

architecture Behavioral of mux_8 is

begin

	with sel select m_out 
	<= m_in_0 when "00",
		m_in_1 when "01",
		m_in_2 when "10", 
		m_in_0 when "11"; 

end Behavioral;
