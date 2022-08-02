----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/07/29 11:03:49
-- Design Name: 
-- Module Name: counter_test - Behavioral
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

entity counter_test is
--  Port ( );
end counter_test;

architecture Behavioral of counter_test is

component counter is port 
(
	input : in std_logic_vector ( 5 downto 0); 
	output : out std_logic_vector ( 5 downto 0); 
	Load : in std_logic; 
	inc : in std_logic := '0';
	m_clk : in std_logic
); 
end component; 

signal clk : std_logic := '0';
signal input : std_logic_vector( 5 downto 0) ; 
signal output : std_logic_vector( 5 downto 0); 
signal load : std_logic := '0';  

begin

coutner_test : counter port map ( 
	input => input, 
	output => output,
	Load => load, 
	m_clk => clk
	); 
	
clk_process : process
begin 
	clk <= '0'; 
	wait for 10 ns; 
	clk <= '1'; 
	wait for 10 ns; 
end process; 

counter_test : process
begin 
	input <= "110000"; 
	load <= '0'; 
	wait for 30ns; 
	load <= '1'; 
	wait for 10ns; 
end process; 


end Behavioral;
