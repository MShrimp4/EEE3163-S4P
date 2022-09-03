library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu_test is
end cpu_test;

architecture Behavioral of cpu_test is
  constant clk_period : time := 25ns;
  signal   clk        : std_logic := '0';

  signal data : STD_LOGIC_VECTOR(3 downto 0);
  signal addr : STD_LOGIC_VECTOR(7 downto 0);

  signal RD,WR : STD_LOGIC;
  signal reset : STD_LOGIC := '0';
  
  component RAM
    Port(
    clk : in STD_LOGIC;
    
    data : inout STD_LOGIC_VECTOR(3 downto 0);
    addr : in    STD_LOGIC_VECTOR(7 downto 0);
    
    RD : in STD_LOGIC;
    WR : in STD_LOGIC
    );
  end component;
begin
  clk  <= not clk  after clk_period/2;

  c_ram : RAM
    port map(
      clk=>  clk,
      data=> data,
      addr=> addr,

      RD=> RD,
      WR=> WR
      );

  cpu : entity work.cpu_project (Behavioral)
    port map(
      Data  => data,--: inout std_logic_vector(3 downto 0); 
      addr  => addr,--: out std_logic_vector(7 downto 0); 
      m_clk => clk,--: in std_logic; 
      
      bRD   => RD,--: out std_logic; 
      bWR   => WR,--: out std_logic; 
      reset => reset--: in std_logic
      );

  test_process : process
  begin
    wait for clk_period*5/2;
    reset <= not reset;
    wait for clk_period*100;
    reset <= not reset;
    wait for clk_period*5/2;
  end process test_process;
end Behavioral;