----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/06/28 23:41:03
-- Design Name: 
-- Module Name: reg_test - Behavioral
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

entity reg_test is
--  Port ( );
end reg_test;

architecture Behavioral of reg_test is

signal clk : std_logic; 
signal en : std_logic:='0'; 
signal r_in : std_logic_vector (3 downto 0); 
signal r_out : std_logic_vector (3 downto 0); 
signal s_out : std_logic; 
signal s : std_logic_vector(1 downto 0) := "11"; 

component reg is port(
  clk : in std_logic; 
  en : in std_logic:='0'; 
  r_in : in std_logic_vector( 3 downto 0);
  r_out : out std_logic_vector(3 downto 0); -- 그냥 출력
  s_out : out std_logic; --shift 출력
  s : in std_logic_vector(1 downto 0) --shift 
); 
end component; 

begin
sim : reg port map( 
clk => clk, 
en => en,
r_in => r_in, 
r_out => r_out,
s_out => s_out, 
s => s); 

clk_process : process 
begin 
clk <= '1'; 
wait for 10 ns; 
clk <= '0'; 
wait for 10 ns;  
end process; 

reg_test : process
begin 
en <= '1'; 
r_in <= "0010"; 
wait for 20 ns; 
r_in <= "0001"; 
wait for 20 ns; 
en <= '0'; 
wait for 60 ns; 
end process; 


end Behavioral;
