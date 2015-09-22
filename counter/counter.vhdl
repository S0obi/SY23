library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    GENERIC (
      Nbits: integer := 4;
      Nmax: integer := 9
    );
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture counter_architecture of counter is

signal cpt : STD_LOGIC_VECTOR (3 downto 0);
signal enable : STD_LOGIC;

begin

  Q <= cpt;

  count: process(clk)
  begin
   if rising_edge(clk) then
     if reset='1' then
	     cpt <= (others => '0');
	  elsif enable = '1' then
		  cpt <= cpt + 1;
	  end if;
   end if;
  end process count;

end counter_architecture;
