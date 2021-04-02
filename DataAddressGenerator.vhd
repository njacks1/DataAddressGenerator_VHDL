library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DataAddressGenerator is
    port(
        DMD : inout std_logic_vector(15 downto 0);          --DMD Bus
        clk : in std_logic;                                 --Clock for registers
        bit_reversal_enable : in std_logic;                 --Enable bit for the bit reversal function
        mux_select : in std_logic_vector(6 downto 0);       --Mux Selects
        register_load : in std_logic_vector(11 downto 0);   --Register load bits
        tristate_enable : in std_logic_vector(2 downto 0);  --Tri State Buffer enable bits
        reset : in std_logic;
        address : out std_logic_vector(13 downto 0)         --Address generated from Data Address Generator
    );
end DataAddressGenerator;

architecture behav of DataAddressGenerator is

    component Adder14Bit is  
        port( 
            input1  :   in std_logic_vector(13 downto 0);  --Input from I registers
            input2  :   in std_logic_vector(13 downto 0);  --Input from M registers
            output  :   out std_logic_vector(13 downto 0)); --Output to Modulous Logic
        end component;

    component BitReverse14Bit is  
        port( 
            enable  :   in std_logic;  --Bit Reverse Enable
            input  :   in std_logic_vector(13 downto 0);  --Input to be reversed
            output  :   out std_logic_vector(13 downto 0)); --Output of reversed bits
        end component;
    
    component ModulusLogic is  
        port( 
            input_lreg  :   in std_logic_vector(13 downto 0);  --Input from I registers
            input_adder  :   in std_logic_vector(13 downto 0);  --Input from M registers
            output  :   out std_logic_vector(13 downto 0)); --Output to Modulous Logic
        end component;
    
    component Mux2to1_14bit is
        Port(sel : in std_logic;    --Selector bit
            input1 : in std_logic_vector(13 downto 0);  --Input signal 1
            input2 : in std_logic_vector(13 downto 0);  --Input signal 2
            output : out std_logic_vector(13 downto 0));    --Output signal
        end component;
    
    component Mux4to1_14bit is
        Port(sel : in std_logic_vector(1 downto 0);    --Selector bits
            input1 : in std_logic_vector(13 downto 0);  --Input signal 1
            input2 : in std_logic_vector(13 downto 0);  --Input signal 2
            input3 : in std_logic_vector(13 downto 0);  --Input signal 3
            input4 : in std_logic_vector(13 downto 0);  --Input signal 4
            output : out std_logic_vector(13 downto 0));    --Output signal
        end component;
    
    component Register14 is
        Port(
            clk : in STD_LOGIC;
            load : in STD_LOGIC;    --Make sure this is hard coded to be 1
            reset : in STD_LOGIC;
            input : in STD_LOGIC_VECTOR(13 downto 0);
            output : inout STD_LOGIC_VECTOR(13 downto 0));
        end component;
    
    component TriStateBuffer_16Bit_special is
        Port(enable : in std_logic;    --Enable bit
            input : in std_logic_vector(13 downto 0);  --Input signal from M Register
            output : out std_logic_vector(15 downto 0));    --Output signal to DMD
        end component;
    
    component TriStateBuffer_16Bit is
        Port(enable : in std_logic;    --Enable bit
            input : in std_logic_vector(13 downto 0);  --Input signal from L or I Registers
            output : out std_logic_vector(15 downto 0));    --Output signal to DMD
        end component;

    signal sig0, sig1, sig2, sig3 : std_logic_vector(13 downto 0);                --L Register Signals
    signal sig4, sig5, sig6, sig7 : std_logic_vector(13 downto 0);                --I Register Signals
    signal sig8, sig9, sig10, sig11 : std_logic_vector(13 downto 0);              --M Register Signals
    signal sig12 : std_logic_vector(13 downto 0);                                 --L-Mux output  
    signal sig13 : std_logic_vector(13 downto 0);                                 --I-Mux output  
    signal sig14 : std_logic_vector(13 downto 0);                                 --M-Mux output
    signal sig15 : std_logic_vector(13 downto 0);                                 --I-Mux input
    signal sig16 : std_logic_vector(13 downto 0);                                 --Modulus Logic output
    signal sig17 : std_logic_vector(13 downto 0);                                 --Adder output 

	begin
        --This stuff needs to change------------
        --stk_underflow <= sig10(0) or sig10(1);
        --stk_overflow <= sig9(0) or sig9(1);
	    --sig15 <= sig2 and sig3;
        ----------------------------------------

        --L Registers
        L0 : Register14 port map(clk, register_load(0), reset, DMD(13 downto 0), sig0);
        L1 : Register14 port map(clk, register_load(1), reset, DMD(13 downto 0), sig1);
        L2 : Register14 port map(clk, register_load(2), reset, DMD(13 downto 0), sig2);
        L3 : Register14 port map(clk, register_load(3), reset, DMD(13 downto 0), sig3);

        --I Registers
        I0 : Register14 port map(clk, register_load(4), reset, sig15, sig4);
        I1 : Register14 port map(clk, register_load(5), reset, sig15, sig5);
        I2 : Register14 port map(clk, register_load(6), reset, sig15, sig6);
        I3 : Register14 port map(clk, register_load(7), reset, sig15, sig7);

        --M Registers
        M0 : Register14 port map(clk, register_load(8), reset, DMD(13 downto 0), sig8);
        M1 : Register14 port map(clk, register_load(9), reset, DMD(13 downto 0), sig9);
        M2 : Register14 port map(clk, register_load(10), reset, DMD(13 downto 0), sig10);
        M3 : Register14 port map(clk, register_load(11), reset, DMD(13 downto 0), sig11);

        --MUXs
        L_MUX : Mux4to1_14bit port map(mux_select(1 downto 0), sig0, sig1, sig2, sig3, sig12);           --L(0 to 3) output MUX
        I_MUX : Mux4to1_14bit port map(mux_select(3 downto 2), sig4, sig5, sig6, sig7, sig13);           --I(0 to 3) output MUX
        M_MUX : Mux4to1_14bit port map(mux_select(5 downto 4), sig8, sig9, sig10, sig11, sig14);           --M(0 to 3) output MUX
        L_Sel_MUX : Mux2to1_14bit port map(mux_select(6), sig16, DMD(13 downto 0), sig15);       --L input MUX

        --14Bit Adder
        Adder : Adder14Bit port map(sig13, sig14, sig17);              --(I + M)

        --Modulus Logic
        Modulus : ModulusLogic port map(sig12, sig17, sig16);          --Provides Linear or Circular Buffer functionality

        --Bit Reverse
        Reverse : BitReverse14Bit port map(bit_reversal_enable, sig13, address);       --Reverse I register is enabled, otherwise is simply a passthrough with no change

        --TriStateBuffers
        L_TSB : TriStateBuffer_16Bit port map(tristate_enable(2), sig12, DMD);              --Always disable this for Demo
        I_TSB : TriStateBuffer_16Bit port map(tristate_enable(1), sig13, DMD);              --Always disable this for Demo
        M_TSB : TriStateBuffer_16Bit_special port map(tristate_enable(0), sig14, DMD);      --Always disable this for Demo
    
    end behav;