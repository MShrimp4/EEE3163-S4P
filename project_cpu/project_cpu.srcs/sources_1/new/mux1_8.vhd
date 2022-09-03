library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux1_to_n is
  Generic(m_len : integer := 8;
          s_len : integer := 3);
  Port ( 
  m_in : in std_logic_vector (m_len-1 downto 0); 
  sel :  in std_logic_vector (s_len-1 downto 0); 
  m_out : out std_logic
  );
end mux1_to_n;

architecture Behavioral of mux1_to_n is

begin
	m_out <= m_in(to_integer(unsigned(sel)));
end Behavioral;
