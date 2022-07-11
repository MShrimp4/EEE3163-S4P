----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/06/30 00:19:09
-- Design Name: 
-- Module Name: pc_cnt_test - Behavioral
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

entity pc_cnt_test is
--  Port ( );
end pc_cnt_test;

architecture Behavioral of pc_cnt_test is

signal clk : std_logic; 
signal PH_en : std_logic:= '0'; 
signal  PL_en : std_logic:= '0'; 
signal  PH : std_logic_vector(3 downto 0) := "0000"; 
signal  PL : std_logic_vector(3 downto 0) := "1110"; 
signal  c_en : std_logic :='1'; 
signal clr : std_logic:='1'; --active low 
signal  pc_out : std_logic_vector(7 downto 0); 

component pc_cnt is port 
(
  clk : in std_logic; 
  PH_en : in std_logic; 
  PL_en : in std_logic; 
  PH : in std_logic_vector(3 downto 0); 
  PL : in std_logic_vector(3 downto 0); 
  c_en : in std_logic :='1'; 
  clr : in std_logic:='1'; --active low 
  pc_out : out std_logic_vector(7 downto 0)
); 
end component; 

begin

sim : pc_cnt port map( 
clk => clk, 
PH_en => PH_en,
PL_en => PL_en, 
PH => PH,
PL => PL, 
c_en => c_en, 
clr => clr, 
pc_out => pc_out
); 

clk_process : process 
begin 
clk <= '1'; 
wait for 10 ns; 
clk <= '0'; 
wait for 10 ns;  
end process; 



end Behavioral;
