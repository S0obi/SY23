----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:02:56 09/23/2015
-- Design Name:
-- Module Name:    lcd_display - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lcd_display is
    Port ( clk : in  STD_LOGIC;
			  data: in STD_LOGIC_VECTOR(7 downto 0);
			  wr: in STD_LOGIC;
			  lcd_rw : out STD_LOGIC;
			  lcd_rs : out STD_LOGIC;
			  lcd_en : out STD_LOGIC;
			  lcd_data : out STD_LOGIC_VECTOR(3 downto 0)
    );
end lcd_display;

architecture Behavioral of lcd_display is
	component counter is
		GENERIC (
      Nbits: integer := 32;
      Nmax: integer := 9
		);
		Port ( clk : in  STD_LOGIC;
				 reset_counter : in  STD_LOGIC;
				 Q : out  STD_LOGIC_VECTOR (Nbits-1 downto 0));
	end component;
	constant t_start_to_init0: integer := 750000;	-- 15ms
	constant t_init0_to_init1: integer := 950000;	-- 19ms
	constant t_init1_to_init2: integer := 1050000;	-- 21ms
	constant t_init2_to_init3: integer := 1150000;	-- 23ms
	constant t_init3_to_set  : integer := 1155000;	-- 23,1ms
	constant t_set_to_entry  : integer := 1160000;	-- 23,2ms
	constant t_entry_to_on   : integer := 1165000;	-- 23,3ms
	constant t_on_to_clear   : integer := 1170000;	-- 23,4ms
	constant t_clear_to_ready: integer := 1270000;  -- 25,4ms
	type T_etat is (start, init0, init1, init2, init3, set, entry, state_on, clear, ready, setaddress, writeaddress, writedata);
	signal next_state, state_reg : T_etat;
begin

  data <= "10000001";

	state_reg_process: process(clk)
	begin
		if rising_edge(clk) then
			if state_reg /= ready then
				state_reg <= start;
				reset_counter <= '1';
				reset_counter <= '0';
				case Q is
					when t_start_to_init0 =>
						state_reg <= init0;
						D <= (7 downto 4 => x"3");
					when t_init0_to_init1 =>
						state_reg <= init1;
						D <= (7 downto 4 => x"3");
					when t_init1_to_init2 =>
						state_reg <= init2;
						D <= (7 downto 4 => x"3");
					when t_init2_to_init3 =>
						state_reg <= init3;
						D <= (7 downto 4 => x"2");
					when t_init3_to_set =>
						state_reg <= set;
						D <= (7 downto 4 => x"2");
						D <= (7 downto 4 => x"8");
					when t_set_to_entry =>
						state_reg <= entry;
						D <= (7 downto 4 => x"0");
						D <= (7 downto 4 => x"6");
					when t_entry_to_on =>
						state_reg <= state_on;
						D <= (7 downto 4 => x"0");
						D <= (7 downto 4 => x"C");
					when t_on_to_clear =>
						state_reg <= clear;
						D <= (7 downto 4 => x"0");
						D <= (7 downto 4 => x"1");
					when t_clear_to_ready =>
						state_reg <= ready;
						state_reg <= next_state;
				end case;
        end if;
		end if;
	end process state_reg_process;

	next_state_process: process(state_reg)
	begin
		next_state <= state_reg;
		case state_reg is
			when clear =>
        reset_counter <= '1';
			  reset_counter <= '0';
        if Q="100000" then -- 2ms
          next_state <= ready;
          D(7 downto 4) <= x"0";
          D(7 downto 4) <= x"1";
        end if;
        when ready =>
          if wr='1' and data=x"C" then
            next_state <= clear;
			    else if wr='1' and data/=x"D" and data/=x"A" and data/=x"C" then
				    next_state <= writedata;
          end if;
        when writedata =>
          LCD_DATA <= data(3 downto 0);
          LCD_EN <= '1';
          reset_counter <= '1';
          reset_counter <= '0';
          case Q is
           when "50" => -- 1µs
          	LCD_EN <= '0';
          	LCD_DATA <= data(7 downto 4);
          	LCD_EN <= '1';
           when "100" => -- 1+1µs
          	LCD_EN <= '0';
           when "2100" => -- 40+1+1µs
          	next_state <= ready;
          end case;
    end case;
	end process next_state_process

end architecture Behavioral;
