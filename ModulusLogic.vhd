library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ModulusLogic is  
port( 
    input_lreg  :   in std_logic_vector(13 downto 0);  --Input from L registers
    input_adder  :   in std_logic_vector(13 downto 0);  --Input from M registers
    output  :   out std_logic_vector(13 downto 0)); --Output to Modulous Logic
end ModulusLogic;

architecture behav of ModulusLogic is
    begin
        process(input_adder)
            variable i : integer;
	    variable L : integer;
            variable o : integer;
            begin
		i := to_integer(unsigned(input_adder));
            	L := to_integer(unsigned(input_lreg));
                if(L = 0) then
                    output <= input_adder;  --Linear
                else    --Circular Buffer
                    o := i mod(L);
                    output <= std_logic_vector(to_unsigned(o, 14));
                end if;
            end process;
    end behav;