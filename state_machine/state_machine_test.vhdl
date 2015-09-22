LIBRARY ieee;
LIBRARY std;
use ieee.std_logic_textio.all;
use std.textio.all;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity state_machine_test is
end state_machine_test;

architecture behavior of state_machine_test is

    -- Component Declaration for the Unit Under Test (UUT)
    component state_machine
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           state_input : in STD_LOGIC;
           tc : out STD_LOGIC);
    end component;

   signal tb_clk, tb_reset, tb_state_input, tb_tc: STD_LOGIC;

   signal clk_te : STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_te_period : time := 20 ns;
   constant dT : real := 2.0; --ns
   constant separator: String(1 to 1) := ";"; -- CSV separator

begin
  -- Instantiate the Unit Under Test (UUT)
  uut: state_machine PORT MAP (
    clk => tb_clk,
    reset => tb_reset,
    state_input => tb_state_input,
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
      -- apply the reset signal
      tb_reset <= '1';
      wait for clk_period*10;
      tb_reset <= '0';

      -- apply the first input
      wait for clk_period*10;
      tb_state_input <= '1';
      wait for clk_period*10;
      tb_state_input <= '0';

      -- apply the second input
      wait for clk_period*20;
      tb_state_input <= '1';
      wait for clk_period*10;
      tb_state_input <= '0';
      wait;
   end process stim_proc;

  result: process(clk_te)
    file filedatas: text open WRITE_MODE is "state_machine.csv";
    variable s : line;
    variable temps : real := 0.0;
    begin
        write(s, temps); write(s, separator);
        write(s, clk_te);   write(s, separator);
        write(s, tb_state_input); write(s, separator);
        write(s, tb_reset); write(s, separator);
        write(s, tb_tc); write(s, separator);

        writeline(filedatas,s);
        temps := temps + dT;
    end process result;

end architecture behavior;
