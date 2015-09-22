library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
    GENERIC (
      N: positive := 60
    );
    Port ( clk : in  STD_LOGIC;
           tc : out  STD_LOGIC);
end divider;

architecture divider_architecture of divider is

signal cpt : STD_LOGIC_VECTOR (3 downto 0);

begin
  count: process(clk)
  begin
    if rising_edge(clk) then
      if cpt < N -1 then
        cpt <= cpt + 1;
      else
        cpt <= (others => '0');
      end if;
    end if;
  end process count;

  remainder: process(cpt)
  begin
    if cpt = N-1 then
      tc <= '1';
    else
      tc <= '0';
    end if;
  end process remainder;

end divider_architecture;
