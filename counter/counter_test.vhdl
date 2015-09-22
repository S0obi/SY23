LIBRARY ieee;
LIBRARY std;
use ieee.std_logic_textio.all;
use std.textio.all;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity counter_test is
end counter_test;

architecture behavior of counter_test is

    -- Component Declaration for the Unit Under Test (UUT)
    component counter
    GENERIC (
      Nbits: integer := 4;
      Nmax: integer := 9
    );
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         Q : OUT  std_logic_vector(Nbits-1 downto 0)
        );
    end component;

   signal tb_clk, tb_reset: STD_LOGIC;
   signal tb_Q : STD_LOGIC_VECTOR(3 downto 0);

   signal clk_te : STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_te_period : time := 20 ns;
   constant dT : real := 2.0; --ns
   constant separator: String(1 to 1) := ";"; -- CSV separator

begin
	-- Instantiate the Unit Under Test (UUT)
  uut: counter PORT MAP (
    clk => tb_clk,
    reset => tb_reset,
    Q => tb_Q
  );

   -- Clock process definitions
   clk_process: process
   begin
		tb_clk <= '0';
		wait for clk_period/2;
		tb_clk <= '1';
		wait for clk_period/2;
   end process clk_process;

   -- Clock process definitions
   clk_te_process: process
   begin
    clk_te <= '0';
    wait for clk_te_period/2;
    clk_te <= '1';
    wait for clk_te_period/2;
   end process clk_te_process;

   -- Stimulus process
   stim_proc: process
   begin
      --wait for 100ms;
      tb_reset <= '1';
      wait for clk_period*10;
      tb_reset <= '0';
      -- insert stimulus here
      wait;
   end process stim_proc;

  result: process(clk_te)
    file filedatas: text open WRITE_MODE is "counter.csv";
    variable s : line;
    variable temps : real := 0.0;
    variable sdata, sbardata : integer := 0;
    variable olddata : std_logic_vector(3 downto 0) := x"0";
    begin
      --if rising_edge(clk_te) then
        write(s, temps); write(s, separator);
        write(s, clk_te);   write(s, separator);
        write(s, tb_reset); write(s, separator);

        if olddata /= tb_Q then
          sdata := 1 - sdata;
        else
          sdata := sdata;
        end if;

        sbardata := 1 - sdata;
        write(s, sdata); write(s, separator);
        write(s, sbardata); write(s, separator);
        writeline(filedatas,s);
        temps := temps + dT;
        olddata := tb_Q;
      --end if;
    end process result;

end architecture behavior;
