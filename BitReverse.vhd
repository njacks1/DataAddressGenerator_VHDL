library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity BitReverse14Bit is  
port( 
    enable  :   in std_logic;  --Bit Reverse Enable
    input  :   in std_logic_vector(13 downto 0);  --Input to be reversed
    output  :   out std_logic_vector(13 downto 0)); --Output of reversed bits
end BitReverse14Bit;

architecture behav of BitReverse14Bit is
    signal temp : std_logic_vector(13 downto 0);
    begin
        process(enable, input)
            begin
                if(enable = '1') then
                    temp(0) <= input(13);
                    temp(1) <= input(12);
                    temp(2) <= input(11);
                    temp(3) <= input(10);
                    temp(4) <= input(9);
                    temp(5) <= input(8);
                    temp(6) <= input(7);
                    temp(7) <= input(6);
                    temp(8) <= input(5);
                    temp(9) <= input(4);
                    temp(10) <= input(3);
                    temp(11) <= input(2);
                    temp(12) <= input(1);
                    temp(13) <= input(0);
                else
                    temp <= input;
                end if;
            output <= temp;
        end process;
    end behav;