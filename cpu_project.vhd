----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/06/25 00:39:35
-- Design Name: 
-- Module Name: cpu_project - Behavioral
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

entity cpu_project is
  Port ( 
  Data : inout std_logic_vector(3 downto 0); 
  addr : out std_logic_vector(7 downto 0)
  );
end cpu_project;

architecture Behavioral of cpu_project is


component reg is port(
  clk : in std_logic; 
  en : in std_logic:='0'; 
  r_in : in std_logic_vector( 3 downto 0); 
  r_out : out std_logic_vector(3 downto 0); -- 그냥 출력
  s_out : out std_logic; --shift 출력
  s : in std_logic_vector(1 downto 0) --shift  
); 
end component;

component flp is port(
	clk : in std_logic; 
  en : in std_logic:='0'; 
  r_in : in std_logic; 
  r_out : out std_logic -- 그냥 출력
); 
end component; 
component alu is port(

	A : in std_logic_vector(3 downto 0); 
	B : in std_logic_vector(3 downto 0); 
	Ci : in std_logic; 
	alufun : in std_logic_vector(1 downto 0):= "00";
	F : out std_logic_vector (3 downto 0); 
	Co : out std_logic:='0'; 
	Z : out std_logic:= '0'
); 
end component; 

component buf is port(
	  Buffer_en : in std_logic;
      
      Data_out : in std_logic_vector(3 downto 0); 
      Data_inout : inout std_logic_vector(3 downto 0)
); 
end component; 

component mux is port(
	m_in : in std_logic_vector(1 downto 0); 
	sel : in std_logic; 
	m_out : out std_logic
); 
end component; 

component mux_idb is port(
  m_in_0 : in std_logic_vector(3 downto 0);
  m_in_1 : in std_logic_vector(3 downto 0);
  m_in_2 : in std_logic_vector(3 downto 0);
  m_in_3 : in std_logic_vector(3 downto 0);
  m_in_4 : in std_logic_vector(3 downto 0);
  m_in_5 : in std_logic_vector(3 downto 0);
  
  Ro_sel : in std_logic_vector(2 downto 0); 
  m_out : out std_logic_vector(3 downto 0) 
); 
end component; 

component pc_cnt is port(
  clk : in std_logic; 
  PH_en : in std_logic := '0'; 
  PL_en : in std_logic := '0'; 
  PH : in std_logic_vector(3 downto 0); 
  PL : in std_logic_vector(3 downto 0); 
  c_en : in std_logic :='0'; 
  clr : in std_logic:='1'; --active low 
  pc_out : out std_logic_vector(7 downto 0)
); 
end component; 

signal IR_en : std_logic; 
signal IR_in : std_logic_vector (3 downto 0); 

signal A_en : std_logic; 
signal A_in : std_logic_vector (3 downto 0); 

signal B_en : std_logic; 
signal B_in : std_logic_vector (3 downto 0); 

signal H_en : std_logic; 
signal H_in : std_logic_vector (3 downto 0); 

signal L_en : std_logic; 
signal L_in : std_logic_vector (3 downto 0); 

signal C_en : std_logic; 
signal C_in : std_logic; 

signal Z_en : std_logic; 
signal Z_in : std_logic; 

signal PH_en : std_logic; 


begin

--IR : reg port map (


end Behavioral;
