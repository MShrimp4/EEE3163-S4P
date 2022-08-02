----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/07/29 16:16:25
-- Design Name: 
-- Module Name: mov_decoder - Behavioral
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

entity mov_decoder is
  Port (
	input_dec : in std_logic_vector(3 downto 0); 
	mov_Rosel : out std_logic_vector(2 downto 0);
	mov_en : out std_logic_vector(8 downto 0)
  );
end mov_decoder;

architecture Behavioral of mov_decoder is

begin

mov_en <= "010000000" when input_dec(3 downto 2) = "00" 
		  else "001000000" when input_dec(3 downto 2) = "01" 
		  else "000100000" when input_dec(3 downto 2) = "10"
		  else "000010000" when input_dec(3 downto 2) = "11" 
		  else "000000000"; 
		  
mov_Rosel <=  "000" when input_dec(1 downto 0)= "00" else
              "001" when input_dec(1 downto 0)= "01" else
			  "010" when input_dec(1 downto 0)= "10" else
			  "011";



end Behavioral;
