library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Register14 is
  Port(
    clk : in STD_LOGIC;
    load : in STD_LOGIC;    --Make sure this is hard coded to be 1
    reset : in STD_LOGIC;
    input : in STD_LOGIC_VECTOR(13 downto 0);
    output : inout STD_LOGIC_VECTOR(13 downto 0));
end Register14;

architecture Behavioral of Register14 is
begin
  process(clk, input, load, reset)
  begin
    if(reset = '0') then
        if(load = '1' and Clk'event and Clk = '1') then 
            output <= input;
	    else
	        output <= output;
        end if;
    else
        output <= "00000000000000";
    end if;
  end process;
end Behavioral;