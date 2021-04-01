library ieee;
use ieee.std_logic_1164.all;
	Entity TriStateBuffer_16Bit is
		Port(enable : in std_logic;    --Enable bit
			input : in std_logic_vector(13 downto 0);  --Input signal from L or I Registers
			output : out std_logic_vector(15 downto 0));    --Output signal to DMD
	end TriStateBuffer_16Bit;
	
	Architecture Behavioral of TriStateBuffer_16Bit is
		begin
			process(input, enable)  --Activate process if Enable or Input change
				begin
					if (enable = '1') then     --If enable is high, input will pass through to output and be padded with two 0's
						output <= "00" & input;
					elsif (enable = '0') then     --If enable is low, input will not pass through to output
						output <= "ZZZZZZZZZZZZZZZZ";
					end if;
			end process;
		end Behavioral;