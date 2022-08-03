----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/08/03 10:32:45
-- Design Name: 
-- Module Name: buf_8 - Behavioral
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

entity buf_8 is
  Port (

	Buffer_en : in std_logic;
      
    Data_in : in std_logic_vector(3 downto 0); 
    Data_out : out std_logic_vector(3 downto 0)   
	);
end buf_8;

architecture Behavioral of buf_8 is

begin
	Data_out <= Data_in when Buffer_en= '1'
			else "ZZZZ" when Buffer_en = '0';  
	

end Behavioral;
