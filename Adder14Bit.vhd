library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder14Bit is  
port( 
    input1  :   in std_logic_vector(13 downto 0);  --Input from I registers
    input2  :   in std_logic_vector(13 downto 0);  --Input from M registers
    output  :   out std_logic_vector(13 downto 0)); --Output to Modulous Logic
end Adder14Bit;

architecture behav of Adder14Bit is
    begin
        output <= std_logic_vector(signed(input1) + signed(input2));	--Cannot add an unsigned and signed together, it must be both of the same type!
    end behav;