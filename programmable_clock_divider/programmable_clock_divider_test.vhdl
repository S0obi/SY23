LIBRARY ieee;
LIBRARY std;
use ieee.std_logic_textio.all;
use std.textio.all;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity programmable_clock_divider_test is
end programmable_clock_divider_test;

architecture behavior of programmable_clock_divider_test is

    -- Component Declaration for the Unit Under Test (UUT)
    component programmable_clock_divider
    GENERIC (
      Nbits: integer := 8;
      Nmax: integer := 128
    );
    PORT(
        clk : in  STD_LOGIC;
        clkdiv: in STD_LOGIC_VECTOR(Nbits-1 downto 0);
        reset: in STD_LOGIC;
        clk_out : out  STD_LOGIC
        );
    end component;

  -- Constants
  constant N: integer := 8;
  constant clk_period : time := 20 ns;
  constant clk_te_period : time := 20 ns;
  constant dT : real := 2.0; --ns
  constant separator: String(1 to 1) := ";"; -- CSV separator

  signal tb_clk, tb_reset, tb_clk_out: STD_LOGIC;
  signal tb_clkdiv : STD_LOGIC_VECTOR(N-1 downto 0);

  signal clk_te : STD_LOGIC;

begin
	-- Instantiate the Unit Under Test (UUT)
  uut: programmable_clock_divider PORT MAP (
    clk => tb_clk,
    clkdiv => tb_clkdiv,
    reset => tb_reset,
    clk_out => tb_clk_out
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
      tb_clkdiv <= "00000100"; -- 4
      wait for clk_period*10;
      tb_reset <= '1';
      wait for clk_period*10;
      tb_reset <= '0';
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
        write(s, clk_te); write(s, separator);
        write(s, tb_clk_out); write(s, separator);
        write(s, tb_reset); write(s, separator);

        writeline(filedatas,s);
        temps := temps + dT;
      --end if;
    end process result;

end architecture behavior;
