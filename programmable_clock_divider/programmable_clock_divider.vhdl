library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity programmable_clock_divider is
    GENERIC (
      Nbits: integer := 8;
      Nmax: integer := 128
    );
    Port ( clk : in  STD_LOGIC;
           clkdiv: in STD_LOGIC_VECTOR(Nbits-1 downto 0);
           reset: in STD_LOGIC;
           clk_out : out  STD_LOGIC);
end programmable_clock_divider;

architecture behavior of programmable_clock_divider is

signal cpt : STD_LOGIC_VECTOR (Nbits-1 downto 0);
signal tmp: STD_LOGIC;

begin

  clk_out <= tmp;

  count: process(reset, clk)
  begin
    if reset = '1' then
      tmp <= '0';
      cpt <= (others => '0');
    elsif rising_edge(clk) then
      if cpt = clkdiv then
        tmp <= NOT(tmp);
        cpt <= (others => '0');
      else
        cpt <= cpt + 1;
      end if;
    end if;
  end process count;

  --remainder: process(cpt,clkdiv)
  --begin
  --  if cpt = clkdiv then
  --    clk_out <= '1';
  --    cpt <= (others => '0');
  --  else
  --    clk_out <= '0';
  --  end if;
  --end process remainder;

end behavior;
