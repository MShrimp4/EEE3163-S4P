
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu_project is
  Port ( 
  Data : inout std_logic_vector(3 downto 0); 
  addr : out std_logic_vector(7 downto 0); 
  m_clk : in std_logic; 
  
  bRD : out std_logic := '1'; 
  bWR : out std_logic := '1'; 
  reset : in std_logic 
  );
end cpu_project;

architecture Behavioral of cpu_project is

component map_rom is 
port ( 
addr : in STD_LOGIC_VECTOR (3 downto 0); 
MIR : out STD_LOGIC_VECTOR (5 downto 0)
);
end component; 

component uop_rom is port (
addr : in STD_LOGIC_VECTOR (5 downto 0); 
Ad_en : out STD_LOGIC; 
Ad_sel : out STD_LOGIC_vector(1 downto 0); 
Dt_en : out STD_LOGIC; 
Dt_dir : out STD_LOGIC; 
bRD : out STD_LOGIC; 
bWR : out STD_LOGIC; 
IR_en : out STD_LOGIC; 
A_en : out STD_LOGIC; 
B_en : out STD_LOGIC; 
PH_en : out STD_LOGIC; 
PL_en : out STD_LOGIC; 
cpc_en : out STD_LOGIC; 
H_en : out STD_LOGIC; 
L_en : out STD_LOGIC; 
C_en : out STD_LOGIC; 
MC_sel : out STD_LOGIC; 
Ci : out STD_LOGIC; 
Z_en : out STD_LOGIC; 
alufun : out STD_LOGIC_VECTOR (1 downto 0); 
Ro_sel : out STD_LOGIC_VECTOR (2 downto 0); 
CA_sel : out STD_LOGIC; 
Mmc_sel : out STD_LOGIC_VECTOR (2 downto 0); 
Next_add : out STD_LOGIC_VECTOR (5 downto 0); 
AS1 : out STD_LOGIC; 
AS0 : out STD_LOGIC; 
AR1_en : out STD_LOGIC; 
AR0_en : out STD_LOGIC; 
Mov_mux_en : out STD_LOGIC; 
Mov_mux_sel : out STD_LOGIC; 
Z_sel : out STD_LOGIC);
end component; 

component mux1_8 is 
  port ( 
  m_in : in std_logic_vector ( 7 downto 0); 
  sel : in std_logic_vector (2 downto 0); 
  m_out : out std_logic
  ); 
end component; 

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
  r_out : out std_logic_vector(3 downto 0); -- ê·¸ëƒ¥ ì¶œë ¥
  s_out : out std_logic; --shift ì¶œë ¥
  s : in std_logic_vector(1 downto 0) --shift  
); 
end component;

component flp is port(
  clk : in std_logic; 
  en : in std_logic:='0'; 
  r_in : in std_logic; 
  r_out : out std_logic -- ê·¸ëƒ¥ ì¶œë ¥
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

component mux_6 is port(
    m_in_0 : in std_logic_vector(5 downto 0); 
	m_in_1 : in std_logic_vector(5 downto 0); 
	sel : in std_logic; 
	m_out : out std_logic_vector(5 downto 0)
); end component; 

component buf_8 is port(
	Buffer_en : in std_logic;
      
    Data_in : in std_logic_vector(7 downto 0); 
    Data_out : out std_logic_vector(7 downto 0)
	); 
end component; 

component mov_decoder is port (
    input_dec : in std_logic_vector(3 downto 0); 
	mov_Rosel : out std_logic_vector(2 downto 0);
	mov_en : out std_logic_vector(8 downto 0)
); 
end component; 

component S4P is port( 
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
  Mmc_sel : in STD_LOGIC_VECTOR (2 downto 0); 
  AS1 : out STD_LOGIC; 
  AS0 : out STD_LOGIC; 
  AR1_en : in STD_LOGIC; 
  AR0_en : in STD_LOGIC; 
--Mov_mux_en : in STD_LOGIC; 
--Mov_mux_sel : in STD_LOGIC; 
  Z_sel : in STD_LOGIC; 
  A_s_in : in std_logic_vector(1 downto 0); 
  
  JZ : out std_logic; -- JZ ê´?? ¨?•´?„œ ?–´?””?„œ ì¶œë ¥?• ì§? ?ƒê°? ì¢? ?•´?•¼?• ?“¯ 
  JC : out std_logic; 
  
  AR0_out : out std_logic_vector( 3 downto 0)
); 
end component; 

component counter is port( 
    input : in std_logic_vector ( 5 downto 0); 
	m_out : out std_logic_vector ( 5 downto 0); 
	Load : in std_logic; 
	inc : in std_logic;
	m_clk : in std_logic
); 
end component; 



signal data_s : std_logic_vector(3 downto 0); 
signal addr_s : std_logic_vector( 7 downto 0);  

signal Op_code : std_logic_vector( 3 downto 0); 


signal clk_s : std_logic; 

signal Ad_en : STD_LOGIC; 
signal Ad_sel_s : STD_LOGIC_vector (1 downto 0); 
signal Dt_en : STD_LOGIC; 
signal Dt_dir : STD_LOGIC; 
signal bRD_s : STD_LOGIC; 
signal bWR_s : STD_LOGIC; 
signal IR_en :STD_LOGIC; 

signal A_en : STD_LOGIC; 
signal B_en : STD_LOGIC; 
signal PH_en : STD_LOGIC; 
signal PL_en : STD_LOGIC; 
signal cpc_en : STD_LOGIC; 
signal H_en : STD_LOGIC; 
signal L_en : STD_LOGIC; 
signal C_en : STD_LOGIC; 
signal MC_sel : STD_LOGIC; 
signal Ci : STD_LOGIC; 
signal Z_en : STD_LOGIC; 
signal alufun : STD_LOGIC_VECTOR (1 downto 0); 
signal Ro_sel_0 : STD_LOGIC_VECTOR (2 downto 0); 
signal Ro_sel_s : std_logic_vector(2 downto 0); 

signal CA_sel : STD_LOGIC; 
signal Next_add : STD_LOGIC_VECTOR (5 downto 0); 
signal AS1 : STD_LOGIC; 
signal AS0 : STD_LOGIC; 
signal AR1_en : STD_LOGIC; 
signal AR0_en : STD_LOGIC; 
signal Mov_mux_en : STD_LOGIC; 
signal Mov_mux_sel : STD_LOGIC; 
signal Z_sel : STD_LOGIC; 

signal A_en_0 : std_logic; 
signal B_en_0 : std_logic; 
signal PH_en_0 : std_logic; 
signal PL_en_0 : std_logic; 
signal H_en_0 : std_logic; 
signal L_en_0 : std_logic; 
signal AR1_en_0 : std_logic; 
signal AR0_en_0 : std_logic;

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
signal AR_2_out : std_logic_vector (3 downto 0); 


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


signal cmp_out : std_logic; 
--signal ad_en : std_logic; 
--signal ad_in , ad_out : std_logic_vector (7 downto 0); 

signal JZ_s, JC_s : std_logic; 

signal NJZ : std_logic; 
signal NRST : std_logic; 


signal mc_out : std_logic; 
signal Nmc_out : std_logic;

signal Mmc_sel : std_logic_vector (2 downto 0);  

signal Ro_sel_rom : std_logic;

signal MIR_out : std_logic_vector(5 downto 0); 
signal NA : std_logic_vector( 5 downto 0); 
signal Mux_CA_out : std_logic_vector( 5 downto 0); 

signal CA_out : std_logic_vector( 3 downto 0); 

signal CAR_out :std_logic_vector (5 downto 0); 

signal dec_en : std_logic_vector ( 8 downto 0); 
signal dec_sel : std_logic_vector ( 2 downto 0); 

signal IR_en_0 : std_logic; 
begin

mux_ca : mux_6 port map ( 
	m_in_0 => MIR_out, 
	m_in_1 => NA, 
	sel => CA_sel, 
	m_out => Mux_CA_out
	); 
	
	
mux_mc : mux1_8 port map (
  m_in(0) => '0',  
  m_in(1) => '1', 
  m_in(2) => JC_s, 
  m_in(3) => NJZ, 
  m_in(4) => NRST, 
  m_in(5) => '0', 
  m_in(6) => '0',  
  m_in(7) => '0', 
  
  sel => Mmc_sel, 
  m_out => mc_out
  ); 

MIR : map_rom port map ( 
	addr => Op_code, 
	MIR => MIR_out
	); 


CAR : counter port map (
	m_clk => clk_s,  
	input => Mux_CA_out, 
	Load => mc_out,  
	m_out => CAR_out,
	inc => Nmc_out
	); 
	
mov_decoder_1 : mov_decoder port map (
	input_dec => AR_0_out, 
	mov_Rosel => dec_sel, 
	mov_en => dec_en
	); 
	

mux_mov_IR : mux port map (
	m_in(1) => dec_en(0),  
	m_in(0) => IR_en_0, 
	sel => Mov_mux_en,
	m_out => IR_en
); 

mux_mov_a : mux port map ( 
	m_in(1) => dec_en(1),  
	m_in(0) => A_en_0, 
	sel => Mov_mux_en,
	m_out => A_en
); 

mux_mov_b : mux port map ( 
	m_in(1) => dec_en(2),  
	m_in(0) => B_en_0, 
	sel => Mov_mux_en,
	m_out => B_en
); 
	
mux_mov_PH : mux port map ( 
	m_in(1) => dec_en(3),  
	m_in(0) => PH_en_0, 
	sel => Mov_mux_en,
	m_out => PH_en
); 
	
	
mux_mov_PL : mux port map ( 
	m_in(1) => dec_en(4),  
	m_in(0) => PL_en_0, 
	sel => Mov_mux_en,
	m_out => PL_en
); 
	
mux_mov_H : mux port map ( 
	m_in(1) => dec_en(5),  
	m_in(0) => H_en_0, 
	sel => Mov_mux_en,
	m_out => H_en
); 

mux_mov_L : mux port map ( 
	m_in(1) => dec_en(6),  
	m_in(0) => L_en_0, 
	sel => Mov_mux_en,
	m_out => L_en
); 
	
mux_mov_AR1 : mux port map ( 
	m_in(1) => dec_en(7),  
	m_in(0) => AR1_en_0, 
	sel => Mov_mux_en,
	m_out => AR1_en
); 

mux_mov_AR0 : mux port map ( 
	m_in(1) => dec_en(8),  
	m_in(0) => AR0_en_0, 
	sel => Mov_mux_en,
	m_out => AR0_en
); 
	
control_rom : uop_rom port map (

addr => CAR_out, 
Ad_en => ad_en, 
Ad_sel => ad_sel_s, 
Dt_en => dt_en, 
Dt_dir => dt_dir, 
bRD => bRD_s, 
bWR => bWR_s, 
IR_en => IR_en_0, 
A_en => A_en_0, 
B_en => B_en_0, 
PH_en => PH_en_0,
PL_en => PL_en_0,
cpc_en => cpc_en, 
H_en => H_en_0, 
L_en => L_en_0, 
C_en => C_en,
MC_sel => MC_sel, 
Ci => Ci, 
Z_en => Z_en, 
alufun => alufun, 
Ro_sel => Ro_sel_0, 
CA_sel => CA_sel, 
Mmc_sel => Mmc_sel, 
Next_add => Next_add, 
AS1 => AS1, 
AS0 => AS0, 
AR1_en => AR1_en_0, 
AR0_en => AR0_en_0, 
Mov_mux_en => Mov_mux_en, 
Mov_mux_sel => Mov_mux_sel, 
Z_sel => Z_sel
); 
	

S4p_comp : S4P port map (
  Data => Data, 
  addr => addr,
  m_clk => clk_s, 
  IR_out => Op_code,  
  
  Ad_en=> Ad_en,  
  Ad_sel => Ad_sel_s, 
  Dt_en => Dt_en, 
  Dt_dir => Dt_dir, 
  bRD => bRD_s, 
  bWR => bWR_s, 
  
  IR_en => IR_en, 
  A_en => A_en,
  B_en => B_en, 
  PH_en => PH_en, 
  PL_en => PL_en, 
  cpc_en => cpc_en, 
  H_en => H_en,
  L_en => L_en, 
  C_en => C_en, 
  MC_sel => MC_sel, 
  Ci => Ci,  
  Z_en => Z_en,  
  alufun => alufun, 
  Ro_sel => Ro_sel_s, 
  CA_sel =>CA_sel,
  Mmc_sel => Mmc_sel, 
  AS1 =>AS1, 
  AS0 =>AS0,
  AR1_en =>AR1_en, 
  AR0_en =>AR0_en, 
--Mov_mux_en : in STD_LOGIC; 
--Mov_mux_sel : in STD_LOGIC; 
  Z_sel => Z_sel,
  A_s_in => A_s_in,
  
  JZ => JZ_s,
  JC => JC_s,
  
  AR0_out =>AR_0_out
); 

NJZ <= not JZ_s; 
NRST <= not reset; 
Nmc_out <= not Mc_out; 

data_s <= Data; 
Data <= data_s; 
addr <= addr_s; 

--A_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "00" else '0' ; 
--B_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "01" else '0' ; 
--H_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "10" else '0' ; 
--L_en <= '1' when Mov_mux_en = '1' AND AR_0_out(3 downto 2) = "11" else '0' ; 

--Ro_sel_dec <= "000" when AR_0_out(1 downto 0)= "00" else
--              "001" when AR_0_out(1 downto 0)= "01" else
--			  "010" when AR_0_out(1 downto 0)= "10" else
--			  "011";
Ro_sel_s <= dec_sel when Mov_mux_en = '1' else Ro_sel_0;

--Alu_Ci <= Ci; 
--Alu_alufun <= alufun; 

--Z_in <= Alu_Z; 
--mux_c_1 <= Alu_Co; 

--Alu_A <= A_out; 
--Alu_B <= B_out; 

--mux_c_1 <= a_s_out; 
--mux_c_2 <= Alu_co;
 


end Behavioral;
