library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu_project is
  Port ( 
  Data : inout std_logic_vector(3 downto 0); 
  addr : out std_logic_vector(7 downto 0); 
  m_clk : in std_logic; 
  
  bRD : out std_logic; 
  bWR : out std_logic; 
  reset : in std_logic 
  );
end cpu_project;

architecture Behavioral of cpu_project is
-- SEL, EN
    signal IR_en, A_en, B_en, PH_en, PL_en, H_en, L_en, AR1_en, AR0_en, cpc_en : STD_LOGIC;
    signal IR_en_0, A_en_0, B_en_0, PH_en_0, PL_en_0, H_en_0, L_en_0, AR1_en_0, AR0_en_0 : STD_LOGIC;
	signal dec_en  : std_logic_vector(8 downto 0);
	
	signal Ro_sel, Ro_sel_0 : STD_LOGIC_VECTOR(2 downto 0);
    signal dec_sel : std_logic_vector(2 downto 0);
    
    signal AS1, AS0: STD_LOGIC;
    
-- REGISTER OUTPUT
    signal AR0: STD_LOGIC_VECTOR(3 downto 0);

-- uPROGRAM
	signal Next_add, CAR_addr, CAR_next_addr: STD_LOGIC_VECTOR(5 downto 0);
    signal CA_sel : STD_LOGIC;
    signal MMC_sel : STD_LOGIC_VECTOR(2 downto 0);

	signal Mov_mux_en, Mov_mux_sel : STD_LOGIC;
	
-- JUMP
    signal JC, JZ, NJZ, NRST, NOT_MMC_out : STD_LOGIC;

-- IR
	signal op_code: STD_LOGIC_VECTOR(3 downto 0);
	signal MIR_out: STD_LOGIC_VECTOR(5 downto 0);

-- ADDR
    signal AD_en:  STD_LOGIC;
    signal AD_sel: STD_LOGIC_VECTOR(1 downto 0);
-- DATA
    signal Dt_en, Dt_dir: STD_LOGIC;

-- ALU
    signal Ci, Z_en, Z_sel: STD_LOGIC;
    signal alufun: STD_LOGIC_VECTOR(1 downto 0);
-- CARRY
    signal C_en, MC_sel : STD_LOGIC;
	
-- MUXMC
    signal MMC_out: STD_LOGIC;
begin

NJZ <= not JZ;
NRST <= not reset;
mux_mc : entity work.mux1_to_n (Behavioral)
generic map (m_len => 8, s_len => 3)
port map (
  m_in(0) => '0',  
  m_in(1) => '1', 
  m_in(2) => JC,
  m_in(3) => NJZ,
  m_in(4) => NRST,
  m_in(5) => '0', 
  m_in(6) => '0',  
  m_in(7) => '0', 
  
  sel => MMC_sel, 
  m_out => MMC_out
  ); 

MIR : entity work.map_rom (Behavioral)
port map ( 
	addr => Op_code, 
	MIR => MIR_out
	); 

mux_ca : entity work.mux_6 (Behavioral) 
    port map ( 
	m_in_0 => Next_add, 
	m_in_1 => MIR_out,
	sel => CA_sel,
	m_out => CAR_next_addr
	); 

NOT_MMC_out <= not MMC_out;
CAR : entity work.counter (Behavioral)
port map (
	m_clk => m_clk,
	input => CAR_next_addr,
	Load => MMC_out,
	m_out => CAR_addr,
	inc => NOT_MMC_out
	); 
	
mov_decoder_1 : entity work.mov_decoder (Behavioral)
port map (
	input_dec => AR0,
	mov_Rosel => dec_sel, 
	mov_en =>    dec_en
	); 

IR_en <= dec_en(8) when Mov_mux_en = '1'
    else IR_en_0;
A_en  <= dec_en(7) when Mov_mux_en = '1'
    else A_en_0;
B_en  <= dec_en(6) when Mov_mux_en = '1'
    else B_en_0;
PH_en <= dec_en(5) when Mov_mux_en = '1'
    else PH_en_0;
PL_en <= dec_en(4) when Mov_mux_en = '1'
    else PL_en_0;
H_en  <= dec_en(3) when Mov_mux_en = '1'
    else H_en_0;
L_en  <= dec_en(2) when Mov_mux_en = '1'
    else L_en_0;
AR1_en<= dec_en(1) when Mov_mux_en = '1'
    else AR1_en_0;
AR0_en<= dec_en(0) when Mov_mux_en = '1'
    else AR0_en_0;

Ro_sel <= dec_sel when Mov_mux_sel = '1' else Ro_sel_0;

control_rom : entity work.uop_rom (Behavioral)
port map (
addr => CAR_addr, 
Ad_en => ad_en, 
Ad_sel => ad_sel, 
Dt_en => dt_en, 
Dt_dir => dt_dir, 
bRD => bRD, 
bWR => bWR, 
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
	

S4p_comp : entity work.S4P (Behavioral)
port map (
  Data => Data, 
  addr => addr,
  m_clk => m_clk,
  IR_out => Op_code,  
  
  Ad_en=> Ad_en,
  Ad_sel => Ad_sel,
  Dt_en => Dt_en,
  Dt_dir => Dt_dir,
  
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
  Ro_sel => Ro_sel, 
  AR1_en =>AR1_en, 
  AR0_en =>AR0_en, 
  Z_sel => Z_sel,
  A_s_in(1) => AS1,
  A_s_in(0) => AS0,
  
  JZ => JZ,
  JC => JC,
  
  AR0_out =>AR0
); 


 


end Behavioral;
