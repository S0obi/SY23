library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity state_machine is
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         state_input : in STD_LOGIC;
         tc : out STD_LOGIC);
end state_machine;

architecture architecture_state_machine of state_machine is
  type T_etat is (idle,edge,one);
  signal next_state, state_reg : T_etat;
  begin

    state_reg_process: process(clk)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          state_reg <= idle;
        else
          state_reg <= next_state;
        end if;
      end if;
    end process state_reg_process;

    tc <= '1' when state_reg = edge else '0';

    next_state_process: process(state_reg, state_input)
    begin
      next_state <= state_reg;
      case state_reg is
        when idle =>
          if state_input = '1' then
            next_state <= edge;
          end if;
        when edge =>
          next_state <= one;
        when one =>
          if state_input = '0' then
            next_state <= idle;
          end if;
      end case;
    end process next_state_process;
end architecture_state_machine;
