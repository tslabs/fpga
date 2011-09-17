
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.mul.all;
use work.all_types.all;
use imdct_package.all;

entity imdct3_gen is

port ( dct_in :         in  type_dct;
      prev_line_in :    in  type_dct; 
       dct_out :        out type_dct;
    prev_line_out :     out type_dct
       );
end;

architecture behavioral of imdct3_gen is


begin
process (dct_in, prev_line_in) 

variable lohi, res,s477,s370,s325,s218,s173,s66,s42,s31, s28,s17,s14,s8,s2,s0 : std_logic_vector(31 downto 0);
type type_raw is array ( 35 downto 0) of std_logic_vector (31 downto 0);
variable rawout : type_raw;

begin    


s42 := fix_mul(dct_in(10), 140151431);
s42 := s42 + fix_mul(dct_in(16), -653652607);
lohi := s42;
s31 := fix_mul(dct_in(1), -851856662);
s31 := s31 + fix_mul(dct_in(7), 1064555813);
lohi := lohi + s31;
s0 := fix_mul(dct_in(4), 410903206);
s0 := s0 + fix_mul(dct_in(13), -992008094);
lohi := lohi + s0;
lohi := lohi + fix_mul(dct_in(0), 725409461);
lohi := lohi + fix_mul(dct_in(2), -576921061);
lohi := lohi + fix_mul(dct_in(3), 952420629);
lohi := lohi + fix_mul(dct_in(5), -1024045778);
lohi := lohi + fix_mul(dct_in(6), -232400265);
lohi := lohi + fix_mul(dct_in(8), 46835960);
lohi := lohi + fix_mul(dct_in(9), -1072719859);
lohi := lohi + fix_mul(dct_in(11), 1048289855);
lohi := lohi + fix_mul(dct_in(12), -322880393);
lohi := lohi + fix_mul(dct_in(14), 495798798);
lohi := lohi + fix_mul(dct_in(15), 905584669);
lohi := lohi + fix_mul(dct_in(17), -791645512);
res := lohi;
rawout(0) := res;


s28 := fix_mul(dct_in(10), 992008094);
s28 := s28 + fix_mul(dct_in(16), 410903206);
lohi := s28;
s17 := fix_mul(dct_in(1), -992008094);
s17 := s17 + fix_mul(dct_in(7), 410903206);
lohi := lohi + s17;
lohi := lohi + fix_mul(dct_in(0), 653652607);
lohi := lohi + fix_mul(dct_in(2), -140151431);
lohi := lohi + fix_mul(dct_in(3), 1064555813);
lohi := lohi - s0;
lohi := lohi + fix_mul(dct_in(5), -851856662);
lohi := lohi + fix_mul(dct_in(6), 851856662);
lohi := lohi + fix_mul(dct_in(8), -1064555813);
lohi := lohi + fix_mul(dct_in(9), 140151431);
lohi := lohi + fix_mul(dct_in(11), -653652607);
lohi := lohi + fix_mul(dct_in(12), -653652607);
lohi := lohi + fix_mul(dct_in(14), 140151431);
lohi := lohi + fix_mul(dct_in(15), -1064555813);
lohi := lohi + fix_mul(dct_in(17), 851856662);
res := lohi;
rawout(1) := res;


s14 := fix_mul(dct_in(10), -653652607);
s14 := s14 + fix_mul(dct_in(16), -140151431);
lohi := s14;
s8 := fix_mul(dct_in(4), -992008094);
s8 := s8 + fix_mul(dct_in(13), -410903206);
lohi :=lohi + s8;
s2 := fix_mul(dct_in(1), -1064555813);
s2 := s2 + fix_mul(dct_in(7), -851856662);
lohi := lohi + s2;
lohi := lohi + fix_mul(dct_in(0), 576921061);
lohi := lohi + fix_mul(dct_in(2), 322880393);
lohi := lohi + fix_mul(dct_in(3), 791645512);
lohi := lohi + fix_mul(dct_in(5), 46835960);
lohi := lohi + fix_mul(dct_in(6), 952420629);
lohi := lohi + fix_mul(dct_in(8), -232400265);
lohi := lohi + fix_mul(dct_in(9), 1048289855);
lohi := lohi + fix_mul(dct_in(11), -495798798);
lohi := lohi + fix_mul(dct_in(12), 1072719859);
lohi := lohi + fix_mul(dct_in(14), -725409461);
lohi := lohi + fix_mul(dct_in(15), 1024045778);
lohi := lohi + fix_mul(dct_in(17), -905584669);
res := lohi;
rawout(2) := res;


lohi := fix_mul(dct_in(0), 495798798);
lohi := lohi + s2;
lohi := lohi + fix_mul(dct_in(2), 725409461);
lohi := lohi + fix_mul(dct_in(3), 232400265);
lohi := lohi + s8;
lohi := lohi + fix_mul(dct_in(5), 905584669);
lohi := lohi + fix_mul(dct_in(6), -46835960);
lohi := lohi + fix_mul(dct_in(8), 1024045778);
lohi := lohi + fix_mul(dct_in(9), -322880393);
lohi := lohi + s14;
lohi := lohi + fix_mul(dct_in(11), 1072719859);
lohi := lohi + fix_mul(dct_in(12), -576921061);
lohi := lohi + fix_mul(dct_in(14), 1048289855);
lohi := lohi + fix_mul(dct_in(15), -791645512);
lohi := lohi + fix_mul(dct_in(17), 952420629);
res := lohi;
rawout(3) := res;


lohi := fix_mul(dct_in(0), 410903206);
lohi := lohi + s17;
lohi := lohi + fix_mul(dct_in(2), 992008094);
lohi := lohi + fix_mul(dct_in(3), -410903206);
lohi := lohi - s0;
lohi := lohi + fix_mul(dct_in(5), 992008094);
lohi := lohi + fix_mul(dct_in(6), -992008094);
lohi := lohi + fix_mul(dct_in(8), 410903206);
lohi := lohi + fix_mul(dct_in(9), -992008094);
lohi := lohi + s28;
lohi := lohi + fix_mul(dct_in(11), -410903206);
lohi := lohi + fix_mul(dct_in(12), -410903206);
lohi := lohi + fix_mul(dct_in(14), -992008094);
lohi := lohi + fix_mul(dct_in(15), 410903206);
lohi := lohi + fix_mul(dct_in(17), -992008094);
res := lohi;
rawout(4) := res;


lohi := fix_mul(dct_in(0), 322880393);
lohi := lohi + s31;
lohi := lohi + fix_mul(dct_in(2), 1072719859);
lohi := lohi + fix_mul(dct_in(3), -905584669);
lohi := lohi + s0;
lohi := lohi + fix_mul(dct_in(5), 232400265);
lohi := lohi + fix_mul(dct_in(6), -791645512);
lohi := lohi + fix_mul(dct_in(8), -952420629);
lohi := lohi + fix_mul(dct_in(9), 495798798);
lohi := lohi + s42;
lohi := lohi + fix_mul(dct_in(11), -725409461);
lohi := lohi + fix_mul(dct_in(12), 1048289855);
lohi := lohi + fix_mul(dct_in(14), 576921061);
lohi := lohi + fix_mul(dct_in(15), 46835960);
lohi := lohi + fix_mul(dct_in(17), 1024045778);
res := lohi;
rawout(5) := res;


s477 := fix_mul(dct_in(10), -1064555813);
s477 := s477 + fix_mul(dct_in(16), 851856662);
lohi := s477;
s370 := fix_mul(dct_in(1), -653652607);
s370 := s370 + fix_mul(dct_in(7), 140151431);
lohi := lohi + s370;
lohi := lohi + fix_mul(dct_in(0), 232400265);
lohi := lohi + fix_mul(dct_in(2), 952420629);
lohi := lohi + fix_mul(dct_in(3), -1072719859);
lohi := lohi - s8;
lohi := lohi + fix_mul(dct_in(5), -725409461);
lohi := lohi + fix_mul(dct_in(6), 322880393);
lohi := lohi + fix_mul(dct_in(8), -576921061);
lohi := lohi + fix_mul(dct_in(9), 905584669);
lohi := lohi + fix_mul(dct_in(11), 1024045778);
lohi := lohi + fix_mul(dct_in(12), -791645512);
lohi := lohi + fix_mul(dct_in(14), 46835960);
lohi := lohi + fix_mul(dct_in(15), -495798798);
lohi := lohi + fix_mul(dct_in(17), -1048289855);
res := lohi;
rawout(6) := res;


s325 := fix_mul(dct_in(10), 410903206);
s325 := s325 + fix_mul(dct_in(16), -992008094);
lohi := s325;
s218 := fix_mul(dct_in(1), -410903206);
s218 := s218 + fix_mul(dct_in(7), -992008094);
lohi := lohi + s218;
lohi := lohi + fix_mul(dct_in(0), 140151431);
lohi := lohi + fix_mul(dct_in(2), 653652607);
lohi := lohi + fix_mul(dct_in(3), -851856662);
lohi := lohi - s8;
lohi := lohi + fix_mul(dct_in(5), -1064555813);
lohi := lohi + fix_mul(dct_in(6), 1064555813);
lohi := lohi + fix_mul(dct_in(8), 851856662);
lohi := lohi + fix_mul(dct_in(9), -653652607);
lohi := lohi + fix_mul(dct_in(11), -140151431);
lohi := lohi + fix_mul(dct_in(12), -140151431);
lohi := lohi + fix_mul(dct_in(14), -653652607);
lohi := lohi + fix_mul(dct_in(15), 851856662);
lohi := lohi + fix_mul(dct_in(17), 1064555813);
res := lohi;
rawout(7) := res;


s173 := fix_mul(dct_in(10), 851856662);
s173 := s173 + fix_mul(dct_in(16), 1064555813);
lohi := s173;
s66 := fix_mul(dct_in(1), -140151431);
s66 := s66 + fix_mul(dct_in(7), -653652607);
lohi := lohi + s66;
lohi := lohi + fix_mul(dct_in(0), 46835960);
lohi := lohi + fix_mul(dct_in(2), 232400265);
lohi := lohi + fix_mul(dct_in(3), -322880393);
lohi := lohi + s0;
lohi := lohi + fix_mul(dct_in(5), -495798798);
lohi := lohi + fix_mul(dct_in(6), 576921061);
lohi := lohi + fix_mul(dct_in(8), 725409461);
lohi := lohi + fix_mul(dct_in(9), -791645512);
lohi := lohi + fix_mul(dct_in(11), -905584669);
lohi := lohi + fix_mul(dct_in(12), 952420629);
lohi := lohi + fix_mul(dct_in(14), 1024045778);
lohi := lohi + fix_mul(dct_in(15), -1048289855);
lohi := lohi + fix_mul(dct_in(17), -1072719859);
res := lohi;
rawout(8) := res;


rawout(9) := -rawout(8);

rawout(10) := -rawout(7);

rawout(11) := -rawout(6);

rawout(12) := -rawout(5);

rawout(13) := -rawout(4);

rawout(14) := -rawout(3);

rawout(15) := -rawout(2);

rawout(16) := -rawout(1);


lohi := fix_mul(dct_in(0), -725409461);
lohi := lohi - s31;
lohi := lohi + fix_mul(dct_in(2), 576921061);
lohi := lohi + fix_mul(dct_in(3), -952420629);
lohi := lohi - s0;
lohi := lohi + fix_mul(dct_in(5), 1024045778);
lohi := lohi + fix_mul(dct_in(6), 232400265);
lohi := lohi + fix_mul(dct_in(8), -46835960);
lohi := lohi + fix_mul(dct_in(9), 1072719859);
lohi := lohi - s42;
lohi := lohi + fix_mul(dct_in(11), -1048289855);
lohi := lohi + fix_mul(dct_in(12), 322880393);
lohi := lohi + fix_mul(dct_in(14), -495798798);
lohi := lohi + fix_mul(dct_in(15), -905584669);
lohi := lohi + fix_mul(dct_in(17), 791645512);
res := lohi;
rawout(17) := res;

lohi := fix_mul(dct_in(0), -791645512);
lohi := lohi - s370;
lohi := lohi + fix_mul(dct_in(2), 905584669);
lohi := lohi + fix_mul(dct_in(3), -495798798);
lohi := lohi + s8;
lohi := lohi + fix_mul(dct_in(5), 322880393);
lohi := lohi + fix_mul(dct_in(6), 1048289855);
lohi := lohi + fix_mul(dct_in(8), -1072719859);
lohi := lohi + fix_mul(dct_in(9), -46835960);
lohi := lohi - s477;
lohi := lohi + fix_mul(dct_in(11), 232400265);
lohi := lohi + fix_mul(dct_in(12), -1024045778);
lohi := lohi + fix_mul(dct_in(14), 952420629);
lohi := lohi + fix_mul(dct_in(15), 576921061);
lohi := lohi + fix_mul(dct_in(17), -725409461);
res := lohi;
rawout(18) := res;


lohi := fix_mul(dct_in(0), -851856662);
lohi := lohi - s218;
lohi := lohi + fix_mul(dct_in(2), 1064555813);
lohi := lohi + fix_mul(dct_in(3), 140151431);
lohi := lohi + s8;
lohi := lohi + fix_mul(dct_in(5), -653652607);
lohi := lohi + fix_mul(dct_in(6), 653652607);
lohi := lohi + fix_mul(dct_in(8), -140151431);
lohi := lohi + fix_mul(dct_in(9), -1064555813);
lohi := lohi - s325;
lohi := lohi + fix_mul(dct_in(11), 851856662);
lohi := lohi + fix_mul(dct_in(12), 851856662);
lohi := lohi + fix_mul(dct_in(14), -1064555813);
lohi := lohi + fix_mul(dct_in(15), -140151431);
lohi := lohi + fix_mul(dct_in(17), 653652607);
res := lohi;
rawout(19) := res;


lohi := fix_mul(dct_in(0), -905584669);
lohi := lohi - s66;
lohi := lohi + fix_mul(dct_in(2), 1024045778);
lohi := lohi + fix_mul(dct_in(3), 725409461);
lohi := lohi - s0;
lohi := lohi + fix_mul(dct_in(5), -1072719859);
lohi := lohi + fix_mul(dct_in(6), -495798798);
lohi := lohi + fix_mul(dct_in(8), 1048289855);
lohi := lohi + fix_mul(dct_in(9), 232400265);
lohi := lohi - s173;
lohi := lohi + fix_mul(dct_in(11), -952420629);
lohi := lohi + fix_mul(dct_in(12), 46835960);
lohi := lohi + fix_mul(dct_in(14), 791645512);
lohi := lohi + fix_mul(dct_in(15), -322880393);
lohi := lohi + fix_mul(dct_in(17), -576921061);
res := lohi;
rawout(20) := res;


lohi := fix_mul(dct_in(0), -952420629);
lohi := lohi + s66;
lohi := lohi + fix_mul(dct_in(2), 791645512);
lohi := lohi + fix_mul(dct_in(3), 1048289855);
lohi := lohi + s0;
lohi := lohi + fix_mul(dct_in(5), -576921061);
lohi := lohi + fix_mul(dct_in(6), -1072719859);
lohi := lohi + fix_mul(dct_in(8), 322880393);
lohi := lohi + fix_mul(dct_in(9), 1024045778);
lohi := lohi + s173;
lohi := lohi + fix_mul(dct_in(11), -46835960);
lohi := lohi + fix_mul(dct_in(12), -905584669);
lohi := lohi + fix_mul(dct_in(14), -232400265);
lohi := lohi + fix_mul(dct_in(15), 725409461);
lohi := lohi + fix_mul(dct_in(17), 495798798);
res := lohi;
rawout(21) := res;


lohi := fix_mul(dct_in(0), -992008094);
lohi := lohi + s218;
lohi := lohi + fix_mul(dct_in(2), 410903206);
lohi := lohi + fix_mul(dct_in(3), 992008094);
lohi := lohi - s8;
lohi := lohi + fix_mul(dct_in(5), 410903206);
lohi := lohi + fix_mul(dct_in(6), -410903206);
lohi := lohi + fix_mul(dct_in(8), -992008094);
lohi := lohi + fix_mul(dct_in(9), -410903206);
lohi := lohi + s325;
lohi := lohi + fix_mul(dct_in(11), 992008094);
lohi := lohi + fix_mul(dct_in(12), 992008094);
lohi := lohi + fix_mul(dct_in(14), -410903206);
lohi := lohi + fix_mul(dct_in(15), -992008094);
lohi := lohi + fix_mul(dct_in(17), -410903206);
res := lohi;
rawout(22) := res;


lohi := fix_mul(dct_in(0), -1024045778);
lohi := lohi + s370;
lohi := lohi + fix_mul(dct_in(2), -46835960);
lohi := lohi + fix_mul(dct_in(3), 576921061);
lohi := lohi - s8;
lohi := lohi + fix_mul(dct_in(5), 1048289855);
lohi := lohi + fix_mul(dct_in(6), 725409461);
lohi := lohi + fix_mul(dct_in(8), -495798798);
lohi := lohi + fix_mul(dct_in(9), -952420629);
lohi := lohi + s477;
lohi := lohi + fix_mul(dct_in(11), -791645512);
lohi := lohi + fix_mul(dct_in(12), -232400265);
lohi := lohi + fix_mul(dct_in(14), 905584669);
lohi := lohi + fix_mul(dct_in(15), 1072719859);
lohi := lohi + fix_mul(dct_in(17), 322880393);
res := lohi;
rawout(23) := res;


lohi := fix_mul(dct_in(0), -1048289855);
lohi := lohi + s31;
lohi := lohi + fix_mul(dct_in(2), -495798798);
lohi := lohi + fix_mul(dct_in(3), -46835960);
lohi := lohi + s0;
lohi := lohi + fix_mul(dct_in(5), 791645512);
lohi := lohi + fix_mul(dct_in(6), 1024045778);
lohi := lohi + fix_mul(dct_in(8), 905584669);
lohi := lohi + fix_mul(dct_in(9), 576921061);
lohi := lohi + s42;
lohi := lohi + fix_mul(dct_in(11), -322880393);
lohi := lohi + fix_mul(dct_in(12), -725409461);
lohi := lohi + fix_mul(dct_in(14), -1072719859);
lohi := lohi + fix_mul(dct_in(15), -952420629);
lohi := lohi + fix_mul(dct_in(17), -232400265);
res := lohi;
rawout(24) := res;


lohi := fix_mul(dct_in(0), -1064555813);
lohi := lohi + s17;
lohi := lohi + fix_mul(dct_in(2), -851856662);
lohi := lohi + fix_mul(dct_in(3), -653652607);
lohi := lohi - s0;
lohi := lohi + fix_mul(dct_in(5), -140151431);
lohi := lohi + fix_mul(dct_in(6), 140151431);
lohi := lohi + fix_mul(dct_in(8), 653652607);
lohi := lohi + fix_mul(dct_in(9), 851856662);
lohi := lohi + s28;
lohi := lohi + fix_mul(dct_in(11), 1064555813);
lohi := lohi + fix_mul(dct_in(12), 1064555813);
lohi := lohi + fix_mul(dct_in(14), 851856662);
lohi := lohi + fix_mul(dct_in(15), 653652607);
lohi := lohi + fix_mul(dct_in(17), 140151431);
res := lohi;
rawout(25) := res;


lohi := fix_mul(dct_in(0), -1072719859);
lohi := lohi + s2;
lohi := lohi + fix_mul(dct_in(2), -1048289855);
lohi := lohi + fix_mul(dct_in(3), -1024045778);
lohi := lohi + s8;
lohi := lohi + fix_mul(dct_in(5), -952420629);
lohi := lohi + fix_mul(dct_in(6), -905584669);
lohi := lohi + fix_mul(dct_in(8), -791645512);
lohi := lohi + fix_mul(dct_in(9), -725409461);
lohi := lohi + s14;
lohi := lohi + fix_mul(dct_in(11), -576921061);
lohi := lohi + fix_mul(dct_in(12), -495798798);
lohi := lohi + fix_mul(dct_in(14), -322880393);
lohi := lohi + fix_mul(dct_in(15), -232400265);
lohi := lohi + fix_mul(dct_in(17), -46835960);
res := lohi;
rawout(26) := res;


rawout(27) := rawout(26);

rawout(28) := rawout(25);

rawout(29) := rawout(24);

rawout(30) := rawout(23);

rawout(31) := rawout(22);

rawout(32) := rawout(21);

rawout(33) := rawout(20);

rawout(34) := rawout(19);

rawout(35) := rawout(18);


dct_out(0 ) <= prev_line_in(0) + fix_mul(rawout(0), 0);
prev_line_out(0) <= fix_mul(rawout(18), 1072719859);
dct_out(1 ) <= prev_line_in(1) + fix_mul(rawout(1), 0);
prev_line_out(1) <= fix_mul(rawout(19), 1064555813);
dct_out(2 ) <= prev_line_in(2) + fix_mul(rawout(2), 0);
prev_line_out(2) <= fix_mul(rawout(20), 1048289855);
dct_out(3 ) <= prev_line_in(3) + fix_mul(rawout(3), 0);
prev_line_out(3) <= fix_mul(rawout(21), 1024045778);
dct_out(4 ) <= prev_line_in(4) + fix_mul(rawout(4), 0);
prev_line_out(4) <= fix_mul(rawout(22), 992008094);
dct_out(5 ) <= prev_line_in(5) + fix_mul(rawout(5), 0);
prev_line_out(5) <= fix_mul(rawout(23), 952420629);
dct_out(6 ) <= prev_line_in(6) + fix_mul(rawout(6), 140151431);
prev_line_out(6) <= fix_mul(rawout(24), 905584669);
dct_out(7 ) <= prev_line_in(7) + fix_mul(rawout(7), 410903206);
prev_line_out(7) <= fix_mul(rawout(25), 851856662);
dct_out(8 ) <= prev_line_in(8) + fix_mul(rawout(8), 653652607);
prev_line_out(8) <= fix_mul(rawout(26), 791645512);
dct_out(9 ) <= prev_line_in(9) + fix_mul(rawout(9), 851856662);
prev_line_out(9) <= fix_mul(rawout(27), 725409461);
dct_out(10) <= prev_line_in(10) + fix_mul(rawout(10), 992008094);
prev_line_out(10) <= fix_mul(rawout(28), 653652607);
dct_out(11) <= prev_line_in(11) + fix_mul(rawout(11), 1064555813);
prev_line_out(11) <= fix_mul(rawout(29), 576921061);
dct_out(12) <= prev_line_in(12) + fix_mul(rawout(12), 1073741824);
prev_line_out(12) <= fix_mul(rawout(30), 495798798);
dct_out(13 ) <= prev_line_in(13) + fix_mul(rawout(13), 1073741824);
prev_line_out(13) <= fix_mul(rawout(31), 410903206);
dct_out(14 ) <= prev_line_in(14) + fix_mul(rawout(14), 1073741824);
prev_line_out(14) <= fix_mul(rawout(32), 322880393);
dct_out(15 ) <= prev_line_in(15) + fix_mul(rawout(15), 1073741824);
prev_line_out(15) <= fix_mul(rawout(33), 232400265);
dct_out(16 ) <= prev_line_in(16) + fix_mul(rawout(16), 1073741824);
prev_line_out(16) <= fix_mul(rawout(34), 140151431);
dct_out(17 ) <= prev_line_in(17) + fix_mul(rawout(17), 1073741824);
prev_line_out(17) <= fix_mul(rawout(35), 46835960);



end process;

end behavioral;



ÿÿ