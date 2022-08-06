----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/06/27 09:57:25
-- Design Name: 
-- Module Name: mux_test - Behavioral
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

entity mux_test is
--  Port ( );
end mux_test;


architecture Behavioral of mux_test is

signal m_0 : std_logic_vector(3 downto 0); 
signal m_1 : std_logic_vector(3 downto 0); 
signal m_2 : std_logic_vector(3 downto 0); 
signal m_3 : std_logic_vector(3 downto 0); 
signal m_4 : std_logic_vector(3 downto 0); 
signal m_5 : std_logic_vector(3 downto 0); 
signal m_6 : std_logic_vector(3 downto 0); 
signal m_7 : std_logic_vector(3 downto 0); 

signal Ro_sel_s : std_logic_vector(2 downto 0); 
signal m_out : std_logic_vector(3 downto 0);

component mux_idb is port(

  m_in_0 : in std_logic_vector(3 downto 0);
  m_in_1 : in std_logic_vector(3 downto 0);
  m_in_2 : in std_logic_vector(3 downto 0);
  m_in_3 : in std_logic_vector(3 downto 0);
  m_in_4 : in std_logic_vector(3 downto 0);
  m_in_5 : in std_logic_vector(3 downto 0);
  m_in_6 : in std_logic_vector(3 downto 0);
  m_in_7 : in std_logic_vector(3 downto 0);
  
  Ro_sel : in std_logic_vector(2 downto 0); 
  m_out : out std_logic_vector(3 downto 0) 
);
end component; 

begin

sim : mux_idb port map( 
m_in_0 => m_0, 
m_in_1 => m_1, 
m_in_2 => m_2, 
m_in_3 => m_3, 
m_in_4 => m_4, 
m_in_5 => m_5, 
m_in_6 => m_6, 
m_in_7 => m_7,

Ro_sel => Ro_sel_s, 
m_out => m_out); 

sim_mux : process 
begin 
	m_0 <= "0000"; 
	m_1 <= "0001"; 
	m_2 <= "0010"; 
	m_3 <= "0011"; 
	m_4 <= "0100"; 
	m_5 <= "0101";
	
	wait for 10 ns;
	Ro_sel_s <= "101"; 
	wait for 10 ns;
	Ro_sel_s <= "100"; 
	wait for 10 ns;
	Ro_sel_s <= "011"; 
	wait for 10 ns;
	Ro_sel_s <= "010"; 
	wait for 10 ns;
	Ro_sel_s <= "001"; 
	wait for 10 ns;
	Ro_sel_s <= "000";
end process; 

end Behavioral;
