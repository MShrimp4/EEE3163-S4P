----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/07/26 11:31:08
-- Design Name: 
-- Module Name: S4P - Behavioral
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

entity S4P is
 Port ( 
  Data : inout std_logic_vector(3 downto 0); 
  addr : out std_logic_vector(7 downto 0); 
  m_clk : in std_logic; 
  IR_out : out std_logic_vector (3 downto 0); 
  
  --addr : in STD_LOGIC_VECTOR (5 downto 0); 
  Ad_en : in STD_LOGIC; 
  Ad_sel : in STD_LOGIC_vector(1 downto 0); 
  Dt_en : in STD_LOGIC; 
  Dt_dir : in STD_LOGIC; 
  bRD : out STD_LOGIC; 
  bWR : out STD_LOGIC; 
  IR_en : in STD_LOGIC; 
  A_en : in STD_LOGIC; 
  B_en : in STD_LOGIC; 
  PH_en : in STD_LOGIC; 
  PL_en : in STD_LOGIC; 
  cpc_en : in STD_LOGIC; 
  H_en : in STD_LOGIC; 
  L_en : in STD_LOGIC; 
  C_en : in STD_LOGIC; 
  MC_sel : in STD_LOGIC; 
  Ci : in STD_LOGIC; 
  Z_en : in STD_LOGIC; 
  alufun : in STD_LOGIC_VECTOR (1 downto 0); 
  Ro_sel : in STD_LOGIC_VECTOR (2 downto 0); 
  CA_sel : in STD_LOGIC; 
  Mmc_sel : in STD_LOGIC_VECTOR (1 downto 0); 
  AS1 : out STD_LOGIC; 
  AS0 : out STD_LOGIC; 
  AR1_en : in STD_LOGIC; 
  AR0_en : in STD_LOGIC; 
--Mov_mux_en : in STD_LOGIC; 
--Mov_mux_sel : in STD_LOGIC; 
  Z_sel : in STD_LOGIC; 
  A_s_in : in std_logic_vector(1 downto 0); 
  
  JZ : out std_logic; 
  JC : out std_logic; 
  
  AR0_out : out std_logic_vector(3 downto 0)
  );
end S4P;

architecture Behavioral of S4P is

component adr_reg is
  Port (
	clk : in std_logic; 
	m_in : in std_logic_vector ( 3 downto 0); 
	Load : in std_logic; 
	m_out : out std_logic_vector ( 3 downto 0)
  );
end component;

component reg is port(
  clk : in std_logic; 
  en : in std_logic:='0'; 
  r_in : in std_logic_vector( 3 downto 0); 
  r_out : out std_logic_vector(3 downto 0); -- 그냥 출력
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
	F : inout std_logic_vector (3 downto 0); --이거 out으로 하면 inout~ 하면서 오류뜸 그래서 inout으로 함. ㅇㅇ
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
  m_in_6 : in std_logic_vector(3 downto 0);
  m_in_7 : in std_logic_vector(3 downto 0);
  
  Ro_sel : in std_logic_vector(2 downto 0); 
  m_out : out std_logic_vector(3 downto 0) 
); 
end component; 

component mux_8 is port(
	m_in_0, m_in_1, m_in_2 : in std_logic_vector(7 downto 0); 
	sel : in std_logic_vector(1 downto 0); 
	m_out : out std_logic_vector ( 7 downto 0)
); 
end component; 

component pc_cnt is port(
  clk : in std_logic; 
  PH_en : in std_logic := '0'; 
  PL_en : in std_logic := '0'; 
  PH : in std_logic_vector(3 downto 0); 
  PL : in std_logic_vector(3 downto 0); 
  c_en : in std_logic :='0'; 
  --clr : in std_logic:='1'; --active low 
  pc_out : out std_logic_vector(7 downto 0)
); 
end component; 

component buf_8 is port(
	Buffer_en : in std_logic;
      
    Data_in : in std_logic_vector(7 downto 0); 
    Data_out : out std_logic_vector(7 downto 0) 
	
	); 
end component; 

component cmp is port ( 
  A : in std_logic_vector (3 downto 0); 
  B : in std_logic_vector (3 downto 0); 
  cmp_out : out std_logic
); 
end component; 

signal mux_out : std_logic_vector(3 downto 0); 

signal A_out : std_logic_vector(3 downto 0); 
signal B_out : std_logic_vector(3 downto 0); 
signal C_out : std_logic; 
signal H_out : std_logic_vector(3 downto 0); 
signal L_out : std_logic_vector(3 downto 0); 
signal Z_out : std_logic;  
signal AR_0_out : std_logic_vector(3 downto 0); 
signal AR_1_out : std_logic_vector(3 downto 0); 


signal mux_c_out : std_logic; 

signal Alu_F : std_logic_vector(3 downto 0); 
signal Alu_Co : std_logic; 
signal Alu_Z : std_logic; 
signal pc_out_8 : std_logic_vector ( 7 downto 0); 

signal cmp_out : std_logic; 

signal Data_in : std_logic_vector(3 downto 0); 

signal HL : std_logic_vector( 7 downto 0); 
signal AR : std_logic_vector( 7 downto 0); 

signal mux_add_out : std_logic_vector (7 downto 0); 

begin

IR : reg port map (
  clk => m_clk,  
  en => IR_en,  
  r_in => Data_in,  
  r_out => IR_out, -- 그냥 출력
  s => "11"
  ); 

A : reg port map ( 
  clk => m_clk, 
  en => A_en, 
  r_in => mux_out, 
  r_out => A_out, 
  s => A_s_in
  ); 

B : reg port map ( 
  clk => m_clk, 
  en => B_en, 
  r_in => mux_out, 
  r_out => B_out, 
  s => "11"
  ); 
  
H : reg port map ( 
  clk => m_clk, 
  en => H_en, 
  r_in => mux_out, 
  r_out => H_out,  
  s => "11"
  ); 
   
L : reg port map ( 
  clk => m_clk, 
  en => L_en, 
  r_in => mux_out, 
  r_out => L_out, 
  s => "11"
  ); 

C : flp port map (
  clk => m_clk, 
  en => C_en, 
  r_in => Alu_Co, 
  r_out => C_out
); 

Z : flp port map (
  clk => m_clk, 
  en => Z_en, 
  r_in => Alu_Z, 
  r_out => Z_out
); 

AR_0 : reg port map (
  clk => m_clk, 
  en => AR0_en, 
  r_in => mux_out, --AR_0_in, 
  r_out => AR_0_out,--AR_0_out, 
  s => "11"
); 

AR_1 : reg port map (
  clk => m_clk, 
  en => AR1_en, 
  r_in => mux_out, 
  r_out => AR_1_out, 
  s => "11"
); 

ALU_1 : alu port map (
	A => A_out,  
	B => B_out, 
	Ci=> Ci, 
	alufun => alufun, 
	F => Alu_F, 
	Co => Alu_Co, 
	Z => Alu_Z
); 

mux_c : mux port map ( 
	m_in(0) => Alu_Co, 
	m_in(1) => A_out(3), 
	sel => Mc_sel,  
	m_out => mux_c_out
); 

mux_add_1 : mux_8 port map (
	m_in_0 => pc_out_8, 
	m_in_1 => HL, --(H_out & L_out),  
	m_in_2 => AR, 
	sel => ad_sel,  
	m_out => mux_add_out
); 

--Ad_out_1 : buf port map (
--	Buffer_en => ad_en,      
--    Data_in => ad_in, 
--    Data_out => ad_out 
--); 

mux_idb_1 : mux_idb port map( 
  m_in_0 => A_out,  
  m_in_1 => B_out, 
  m_in_2 => H_out, 
  m_in_3 => L_out, 
  m_in_4 => Alu_F, 
  m_in_5 => Data_in, 
  m_in_6 => AR_1_out,  
  m_in_7 => AR_0_out, 
  
  Ro_sel => Ro_sel, 
  m_out => mux_out
); 

pc_cnt_1 : pc_cnt port map( 
  clk => m_clk, 
  PH_en => H_en, 
  PL_en => L_en, 
  PH => mux_out, 
  PL => mux_out, 
  c_en => cpc_en,   
  --clr => pc_clr, 
  pc_out => pc_out_8
); 

mux_z : mux port map( 
	m_in(0) => Alu_Z, 
	m_in(1) => cmp_out, 
	sel => Mc_sel,  
	m_out => mux_c_out
); 

cmp_1 : cmp port map (
	A => A_out, 
	B => AR_1_out, 
	cmp_out => cmp_out
); 
--mux mc 삭제 
--car 삭제 
HL <= (H_out & L_out); 
AR <= (AR_1_out & AR_0_out); 

Data_in <= Data when Dt_en= '1' and dt_dir = '1' else (others => 'Z');
Data <= mux_out when Dt_en= '1' and dt_dir= '0';  
--mux_D <= Data_in when Dt_en= '1' and dt_dir = '1' else (others => 'Z'); 

JZ <= '1' when Z_out = '1'; 
JC <= '1' when C_out = '1'; 


addr <= mux_add_out when ad_en = '1' 
	 else "ZZZZZZZZ"; 

AR0_out <= AR_0_out; 

end Behavioral;
