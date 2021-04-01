library ieee;
use ieee.std_logic_1164.all;
	Entity TriStateBuffer_16Bit_special is
		Port(enable : in std_logic;    --Enable bit
			input : in std_logic_vector(13 downto 0);  --Input signal from M Register
			output : out std_logic_vector(15 downto 0));    --Output signal to DMD
	end TriStateBuffer_16Bit_special;
	
	Architecture Behavioral of TriStateBuffer_16Bit_special is
		begin
			process(input, enable)  --Activate process if Enable or Input change
				begin
					if (enable = '1') then     --If enable is high, input will pass through to output and be padded with two 0's
                        if(input(13) = '1') then
						    output <= "11" & input;     --If negative, pad with 1's
                        else
                            output <= "00" & input;     --If positive, pad with 0's
                        end if;
					elsif (enable = '0') then     --If enable is low, input will not pass through to output
						output <= "ZZZZZZZZZZZZZZZZ";
					end if;
			end process;
		end Behavioral;