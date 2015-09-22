LIBRARY ieee;
LIBRARY std;
use ieee.std_logic_textio.all;
use std.textio.all;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity clock_divider_test is
end clock_divider_test;

architecture behavior of clock_divider_test is

    -- Component Declaration for the Unit Under Test (UUT)
    component divider
    GENERIC (
      N: integer := 10
    );
    PORT(
         clk : IN  std_logic;
         tc : OUT  std_logic
        );
    end component;

   signal tb_clk, tb_tc: STD_LOGIC;

   signal clk_te : STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_te_period : time := 20 ns;
   constant dT : real := 2.0; --ns
   constant separator: String(1 to 1) := ";"; -- CSV separator

begin
	-- Instantiate the Unit Under Test (UUT)
  uut: divider PORT MAP (
    clk => tb_clk,
    tc => tb_tc
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
      --tb_reset <= '1';
      --wait for clk_period*10;
      --tb_reset <= '0';
      -- insert stimulus here
      wait;
   end process stim_proc;

  result: process(clk_te)
    file filedatas: text open WRITE_MODE is "clock_divider.csv";
    variable s : line;
    variable temps : real := 0.0;
    begin
      --if rising_edge(clk_te) then
        write(s, temps);  write(s, separator);
        write(s, tb_clk); write(s, separator);
        write(s, tb_tc);  write(s, separator);

        writeline(filedatas,s);
        temps := temps + dT;
      --end if;
    end process result;

end architecture behavior;
