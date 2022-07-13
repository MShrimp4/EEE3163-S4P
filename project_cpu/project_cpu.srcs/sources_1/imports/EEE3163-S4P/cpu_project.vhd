
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu_project is
  Port ( 
  Data : inout std_logic_vector(3 downto 0); 
  addr : out std_logic_vector(7 downto 0); 
  m_clk : in std_logic; 
  
  Dt_en : in std_logic; 
  Dt_dir : in std_logic;  
  
  Ro_sel : in std_logic_vector(2 downto 0); 
  
  IR_en, A_en, B_en, PH_en, PL_en, H_en, L_en, C_en, Z_en , Ad_en: in std_logic; 
  Mc_sel , Ad_sel : in std_logic; 
  
  Ci: in std_logic; 
  alufun : in std_logic_vector(1 downto 0); 
  
  CE : in std_logic; 
  
  AR_0_en : in std_logic; 
  AR_1_en : in std_logic; 
  
  pc_clr : in std_logic
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
	sel : in std_logic_vector(2 downto 0); 
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
  clr : in std_logic:='1'; --active low 
  pc_out : out std_logic_vector(7 downto 0)
); 
end component; 

component buf_8 is port(
	Buffer_en : in std_logic;
      
    Data_in : in std_logic_vector(7 downto 0); 
    Data_out : out std_logic_vector(7 downto 0)
	); 
end component; 

signal Data_s : std_logic_vector(3 downto 0); 

signal IR_en_s : std_logic; 
signal IR_in : std_logic_vector (3 downto 0); 
signal IR_out : std_logic_vector ( 3 downto 0);
 
signal A_en_s : std_logic; 
signal A_in : std_logic_vector (3 downto 0); 
signal A_out : std_logic_vector (3 downto 0); 
signal A_s_in : std_logic_vector (1 downto 0); 
signal A_s_out : std_logic; 

--signal B_en : std_logic; 
signal B_in : std_logic_vector (3 downto 0); 
signal B_out : std_logic_vector (3 downto 0); 

--signal H_en : std_logic; 
signal H_in : std_logic_vector (3 downto 0); 
signal H_out : std_logic_vector (3 downto 0); 

--signal L_en : std_logic; 
signal L_in : std_logic_vector (3 downto 0); 
signal L_out : std_logic_vector (3 downto 0); 

--signal C_en : std_logic; 
signal C_in : std_logic_vector (3 downto 0); 
signal C_out : std_logic_vector (3 downto 0); 

--signal Z_en : std_logic; 
signal Z_in : std_logic; 
signal Z_out : std_logic; 

--signal PH_en : std_logic; 
--signal PL_en : std_logic_vector (3 downto 0);  
signal PC_out : std_logic_vector(7 downto 0); 

signal AR_1_en , AR_2_en : std_logic; 
signal AR_1_in , AR_2_in : std_logic_vector (3 downto 0);  
signal AR_1_out, AR_2_out : std_logic_vector (3 downto 0); 


signal Alu_A : std_logic_vector(3 downto 0); 
signal Alu_B : std_logic_vector(3 downto 0); 
signal Alu_F : std_logic_vector(3 downto 0); 
--signal Alu_Ci : std_logic; 
signal Alu_alufun : std_logic_vector(1 downto 0); 
signal Alu_Co : std_logic; 
signal Alu_Z : std_logic; 

signal mux_out : std_logic_vector(3 downto 0); 
signal mux_sel : std_logic_vector(2 downto 0); 

--signal ad_en : std_logic; 
signal ad_in : std_logic_vector (7 downto 0); 
signal ad_out : std_logic_vector (7 downto 0); 

signal mux_c_1 , mux_c_2 , mux_c_out: std_logic; 
signal mux_c_sel : std_logic; 

signal pc_out_8 : std_logic_vector( 7 downto 0); 

signal mux_add_1 , mux_add_2 , mux_add_out : std_logic_vector(7 downto 0); 
signal mux_add_sel : std_logic;  

signal AR_0_out, AR_1_out : std_logic_vector(3 downto 0); 

signal Mov_mux_en : std_logic; 

signal cmp_out : std_logic; 
--signal ad_en : std_logic; 
--signal ad_in , ad_out : std_logic_vector (7 downto 0); 

signal Ro_sel_rom : std_logic; 
begin

IR : reg port map (
  clk => m_clk,  
  en => IR_en,  
  r_in => Data,  
  r_out => IR_out, -- 그냥 출력
  s => "11"
  ); 

A : reg port map ( 
  clk => m_clk, 
  en => A_en, 
  r_in => mux_out, 
  r_out => A_out, 
  s_out => mux_c_2, 
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

C : reg port map (
  clk => m_clk, 
  en => C_en, 
  r_in => mux_c_out, 
  r_out => C_out, 
  s => "11"
); 

Z : reg port map (
  clk => m_clk, 
  en => Z_en, 
  r_in => mux_c_out,  
  r_out => Z_out, 
  s => "11"
); 

AR_0 : reg port map (
  clk => m_clk, 
  en => AR_0_en, 
  r_in => mux_out, --AR_0_in, 
  r_out => AR_0_out,--AR_0_out, 
  s => "11"
); 

AR_1 : reg port map (
  clk => m_clk, 
  en => AR_1_en, 
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
	m_in_1 => (H_out & L_out),  
	m_in_2 => (AR_1_out & AR_0_out), 
	sel => mux_add_sel,  
	m_out => mux_add_out
); 

Ad_out_1 : buf port map (
	Buffer_en => ad_en,      
    Data_in => ad_in, 
    Data_out => ad_out 
); 

mux_idb : mux_idb port map( 
  m_in_0 => A_out,  
  m_in_1 => B_out, 
  m_in_2 => H_out, 
  m_in_3 => L_out, 
  m_in_4 => Alu_F, 
  m_in_5 => Data, 
  m_in_6 => AR_1_out,  
  m_in_7 => AR_0_out, 
  
  Ro_sel => Ro_sel, 
  m_out => mux_out
); 

pc_cnt : pc_cnt port map( 
  clk => m_clk, 
  PH_en => H_en, 
  PL_en => L_en, 
  PH => PH, 
  PL => PL, 
  c_en => CE,   
  clr => pc_clr, 
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
	
IR_in <= Data when Dt_en= '1' and dt_dir = '1' else (others => 'Z'); 
mux_D <= Data when Dt_en= '1' and dt_dir = '0' else (others => 'Z'); 

Data <= mux_out when Dt_en = '1' and dt_dir = '0' else (others => 'Z');
addr <= mux_add_out when ad_en = '1' 
	 else "ZZZZZZZZ"; 

A_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "00" else '0' ; 
B_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "01" else '0' ; 
H_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "10" else '0' ; 
L_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "11" else '0' ; 

Ro_sel_dec <= "000" when AR_0_out(1 downto 0)= "00" else
              "001" when AR_0_out(1 downto 0)= "01" else
			  "010" when AR_0_out(1 downto 0)= "10" else
			  "011";
Ro_sel <= Ro_sel_dec when Mov_mux_en = '1' else Ro_sel_rom;

--Alu_Ci <= Ci; 
--Alu_alufun <= alufun; 

--Z_in <= Alu_Z; 
--mux_c_1 <= Alu_Co; 

--Alu_A <= A_out; 
--Alu_B <= B_out; 

--mux_c_1 <= a_s_out; 
--mux_c_2 <= Alu_co;
 


end Behavioral;
