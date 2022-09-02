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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg is
  Port ( 
  clk : in std_logic; 
  en : in std_logic; 
  r_in : in std_logic_vector( 3 downto 0); 
  r_out : out std_logic_vector(3 downto 0); -- 그냥 출력
  s : in std_logic_vector(1 downto 0); --shift 
  s_out : out std_logic
  );
end Reg;

architecture Behavioral of Reg is

signal r : std_logic_vector(3 downto 0); 

begin

   process(clk)
   begin
   if rising_edge(clk) then 
      if en = '1' then 
      r <= r_in; 
      end if; 
      
      
      if en= '0' then 
         if s= "01" then
            r(3) <= '0'; 
            r(2) <= r(3); 
            r(1) <= r(2); 
            r(0) <= r(1); 
             
         elsif s= "10" then 
            
            r(3) <= r(2); 
            r(2) <= r(1); 
            r(1) <= r(0); 
            r(0) <= '0'; 
         
         else
            r <= r; 
         end if;  
      end if; 
   
   end if; 
   
   end process; 
      
   r_out <= r;  
   s_out <= r(3) when s="10" else r(0);
end Behavioral;