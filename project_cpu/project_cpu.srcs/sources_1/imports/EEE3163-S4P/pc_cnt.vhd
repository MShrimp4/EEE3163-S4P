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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_cnt is
  Port ( 
  clk : in std_logic;
  PH_en : in std_logic; 
  PL_en : in std_logic; 
  PH : in std_logic_vector(3 downto 0); 
  PL : in std_logic_vector(3 downto 0); 
  c_en : in std_logic :='0'; 
  --clr : in std_logic:='1'; --active low 
  pc_out : out std_logic_vector(7 downto 0)
  );
end pc_cnt;

architecture Behavioral of pc_cnt is
signal ph_sig : std_logic_vector ( 3 downto 0) := "0000"; 
signal pl_sig : std_logic_vector ( 3 downto 0) := "0000";
signal p_sig : std_logic_vector(7 downto 0); 

begin
	process(clk)
	begin
	if rising_edge(clk) then
	   if pl_en = '1' then 
		  pl_sig <= pl;
	   elsif ph_en = '1' then 
		  ph_sig <= pl; 
	   elsif c_en = '1' then 
		  pl_sig <= pl_sig + 1; 
		  if pl_sig = "1111" then 
		      ph_sig <= ph_sig + 1; 
		  end if; 
	   end if; 
			
	end if; 
	
	end process; 
	pc_out(7 downto 4) <= ph_sig; 
	pc_out(3 downto 0) <= pl_sig; 
end Behavioral;
