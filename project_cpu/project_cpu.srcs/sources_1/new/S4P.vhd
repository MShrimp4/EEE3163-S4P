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
  
  Ad_en : in STD_LOGIC; 
  Ad_sel : in STD_LOGIC_vector(1 downto 0); 
  
  Dt_en : in STD_LOGIC; 
  Dt_dir : in STD_LOGIC; 
  
  IR_en : in STD_LOGIC; 
  A_en : in STD_LOGIC; 
  B_en : in STD_LOGIC; 
  PH_en : in STD_LOGIC; 
  PL_en : in STD_LOGIC; 
  H_en : in STD_LOGIC; 
  L_en : in STD_LOGIC; 
  AR1_en : in STD_LOGIC; 
  AR0_en : in STD_LOGIC; 
  cpc_en : in STD_LOGIC; 
  
  C_en : in STD_LOGIC; 
  MC_sel : in STD_LOGIC; 
  Ci : in STD_LOGIC; 
  Z_en : in STD_LOGIC; 
  alufun : in STD_LOGIC_VECTOR (1 downto 0); 
  
  Ro_sel : in STD_LOGIC_VECTOR (2 downto 0); 
 
  Z_sel : in STD_LOGIC; 
  A_s_in : in std_logic_vector(1 downto 0); 
  
  JZ : out std_logic; 
  JC : out std_logic; 
  
  AR0_out : out std_logic_vector(3 downto 0)
  );
end S4P;

architecture Behavioral of S4P is

--register out 
signal A_out, B_out, H_out, L_out, AR_0_out, AR_1_out : std_logic_vector(3 downto 0); 
signal pc_out_8 : std_logic_vector (7 downto 0); 

--1bit register  ; 
signal mux_c_out, mux_z_out : std_logic; 

--mux_idb 
signal mux_out : std_logic_vector(3 downto 0); 

--ALU 
signal Alu_F : std_logic_vector(3 downto 0); 
signal Alu_Co, ALU_Z : std_logic; 

 
signal cmp_out : std_logic; 
 
signal Data_4 : std_logic_vector(3 downto 0); 

signal Buffer_in_en : std_logic;
signal Buffer_out_en : std_logic; 
 

signal mux_add_out : std_logic_vector (7 downto 0); 

begin

IR : entity work.reg (Behavioral) 
port map (
  clk => m_clk,  
  en => IR_en,  
  r_in => Data_4,  
  r_out => IR_out, -- 그냥 출력
  s => "11"
  ); 

A : entity work.reg (Behavioral)
port map ( 
  clk => m_clk, 
  en => A_en, 
  r_in => mux_out, 
  r_out => A_out, 
  s => A_s_in
  ); 

B : entity work.reg (Behavioral)
port map ( 
  clk => m_clk, 
  en => B_en, 
  r_in => mux_out, 
  r_out => B_out, 
  s => "11"
  ); 
  
H : entity work.reg (Behavioral)
port map ( 
  clk => m_clk, 
  en => H_en, 
  r_in => mux_out, 
  r_out => H_out,  
  s => "11"
  ); 
   
L : entity work.reg (Behavioral)
port map ( 
  clk => m_clk, 
  en => L_en, 
  r_in => mux_out, 
  r_out => L_out, 
  s => "11"
  ); 

C : entity work.flp (Behavioral)
port map (
  clk => m_clk, 
  en => C_en, 
  r_in => mux_c_out, 
  r_out => JC
); 

Z : entity work.flp (Behavioral)
port map (
  clk => m_clk, 
  en => Z_en, 
  r_in => mux_z_out, 
  r_out => JZ
); 

AR_0 : entity work.reg (Behavioral)
port map (
  clk => m_clk, 
  en => AR0_en, 
  r_in => mux_out, --AR_0_in, 
  r_out => AR_0_out,--AR_0_out, 
  s => "11"
); 

AR_1 : entity work.reg (Behavioral)
port map (
  clk => m_clk, 
  en => AR1_en, 
  r_in => mux_out, 
  r_out => AR_1_out, 
  s => "11"
); 

ALU_1 : entity work.alu (Behavioral)
port map (
   A => A_out,  
   B => B_out, 
   Ci=> Ci, 
   alufun => alufun, 
   F => Alu_F, 
   Co => Alu_Co, 
   Z => Alu_Z
); 

mux_c : entity work.mux (Behavioral)
port map ( 
   m_in(0) => Alu_Co, 
   m_in(1) => A_out(3), 
   sel => Mc_sel,  
   m_out => mux_c_out
); 

mux_add_1 : entity work.mux_8 (Behavioral)
port map (
   m_in_0 => pc_out_8, 
   m_in_1(7 downto 4) => H_out,
   m_in_1(3 downto 0) => L_out,
   m_in_2(7 downto 4) => AR_1_out,
   m_in_2(3 downto 0) => AR_0_out, 
   sel => ad_sel,  
   m_out => mux_add_out
); 

mux_idb_1 : entity work.mux_idb (Behavioral)
port map( 
  m_in_0 => A_out,  
  m_in_1 => B_out, 
  m_in_2 => H_out, 
  m_in_3 => L_out, 
  m_in_4 => Alu_F, 
  m_in_5 => Data_4, 
  m_in_6 => AR_1_out,  
  m_in_7 => AR_0_out, 
  
  Ro_sel => Ro_sel, 
  m_out => mux_out
); 

pc_cnt_1 : entity work.pc_cnt (Behavioral)
port map( 
  clk => m_clk,
  PH_en => ph_en, 
  PL_en => pl_en, 
  PH => mux_out, 
  PL => mux_out, 
  c_en => cpc_en,   
  pc_out => pc_out_8
); 

mux_z : entity work.mux (Behavioral)
port map( 
   m_in(0) => Alu_Z, 
   m_in(1) => cmp_out, 
   sel => Mc_sel, 
   m_out => mux_z_out
); 

cmp_1 : entity work.cmp (Behavioral)
port map (
   A => A_out, 
   B => AR_1_out, 
   cmp_out => cmp_out
); 

buf_in : entity work.buf_8 (Behavioral)
port map (
   Data_in => Data, 
   Buffer_en => Buffer_in_en, 
   Data_out => Data_4
); 
Buffer_in_en <= Dt_en and Dt_dir;  

buf_out : entity work.buf_8 (Behavioral)
port map(
   Data_in => mux_out, 
   Buffer_en => Buffer_out_en, 
   Data_out => Data
); 
Buffer_out_en <= Dt_en and (not Dt_dir);  


addr <= mux_add_out when ad_en = '1' 
    else "ZZZZZZZZ"; 
	
AR0_out <= AR_0_out; 

end Behavioral;