library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vhdl1 is 
    port(
        clk: in std_logic;
        sw: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(3 downto 0)
        );

end entity;

architecture rtl of Vhdl1 is
    constant div : integer := 10_000_000;
    signal div_cnt : integer range 0 to div - 1 := 0 ;
    signal div_clk : std_logic := '0' ;
    signal led_state : std_logic_vector(3 downto 0) := "0000";
    signal sw_state : std_logic_vector(1 downto 0) := "00";
begin
    process(clk)
    begin
        if rising_edge(clk) then 
            if div_cnt = div - 1 then
                div_cnt <= 0;
                div_clk <= not div_clk;
            else
                div_cnt <= div_cnt + 1;
            end if;
            --开关最后的状态
            if sw(0) = '1' then
                sw_state <= "00"; --流水灯
                led_state <= "0001";
            elsif sw(1) = '1' then
                sw_state <= "01"; -- 间隔点亮
                led_state <= "0001";
            elsif sw(2) = '1' then
                sw_state <= "10"; --追逐点亮
                led_state <= "0001";
            elsif sw(3) = '1' then
                sw_state <= "11"; --全部闪
                led_state <= "0000";
            else 
                sw_state <= sw_state;
            end if;
        end if;
    end process;
    
    process (div_clk,sw_state)
    begin
        if rising_edge(div_clk) then
            case sw_state is
                when "00" => 
                    led_state <= led_state rol 1;
                when "01" =>
                    led_state <= led_state rol 2;
                when "10" =>
                    led_state <= (led_state rol 1) or "0001";
                    if led_state = "1111" then
                        led_state <= "0001";
                    end if;
                when "11" =>
                    led_state <= not led_state;
                when others => led_state <= "0000";
                    
            end case;
        end if;
    
    end process;
    led <= led_state;
end architecture;