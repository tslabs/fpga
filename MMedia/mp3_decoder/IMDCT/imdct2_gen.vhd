
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.mul.all;
use work.all_types.all;
use imdct_package.all;

entity imdct2_gen is

port ( dct_in :         in  type_dct;
      prev_line_in :    in  type_dct; 
       dct_out :        out type_dct;
    prev_line_out :     out type_dct
       );
end;

architecture behavioral of imdct2_gen is


begin
process (dct_in, prev_line_in) 

variable lohi, res  : std_logic_vector(31 downto 0);
type type_raw is array ( 35 downto 0) of std_logic_vector (31 downto 0);
variable rawout : type_raw;

begin    

for i in 0 to 35 loop
   for k in 0 to 31 loop
      rawout (i)(k) := '0' ;
   end loop;
end loop;


lohi := fix_mul(dct_in(0), 85318785);
lohi := lohi + fix_mul(dct_in(3), -129483039);
lohi := lohi + fix_mul(dct_in(6), -18293432);
lohi := lohi + fix_mul(dct_in(9), 138952416);
lohi := lohi + fix_mul(dct_in(12), -53633630);
lohi := lohi + fix_mul(dct_in(15), -111189606);
res := lohi;
rawout(6) := rawout (6) + res; -- fix_mul(res, window(6));

lohi := fix_mul(dct_in(0), 157245849);
lohi := lohi + fix_mul(dct_in(3), -379625062);
lohi := lohi + fix_mul(dct_in(6), 379625062);
lohi := lohi + fix_mul(dct_in(9), -157245849);
lohi := lohi + fix_mul(dct_in(12), -157245849);
lohi := lohi + fix_mul(dct_in(15), 379625062);
res := lohi;
rawout(7) := rawout (7) + res; -- fix_mul(res, window(7));

lohi := fix_mul(dct_in(0), 85318785);
lohi := lohi + fix_mul(dct_in(3), -250142023);
lohi := lohi + fix_mul(dct_in(6), 397918495);
lohi := lohi + fix_mul(dct_in(9), -518577479);
lohi := lohi + fix_mul(dct_in(12), 603896265);
lohi := lohi + fix_mul(dct_in(15), -648060518);
res := lohi;
rawout(8) := rawout(8) + res; -- fix_mul(res, window(8));

lohi := fix_mul(dct_in(0), -111189606);
lohi := lohi + fix_mul(dct_in(3), 325991431);
lohi := lohi + fix_mul(dct_in(6), -518577479);
lohi := lohi + fix_mul(dct_in(9), 675823328);
lohi := lohi + fix_mul(dct_in(12), -787012935);
lohi := lohi + fix_mul(dct_in(15), 844568910);
res := lohi;
rawout(9) := rawout(9) + res; -- fix_mul(res, window(9));

lohi := fix_mul(dct_in(0), -379625062);
lohi := lohi + fix_mul(dct_in(3), 916495974);
lohi := lohi + fix_mul(dct_in(6), -916495974);
lohi := lohi + fix_mul(dct_in(9), 379625062);
lohi := lohi + fix_mul(dct_in(12), 379625062);
lohi := lohi + fix_mul(dct_in(15), -916495974);
res := lohi;
rawout(10) := rawout(10) + res; -- fix_mul(res, window(10));

lohi := fix_mul(dct_in(0), -648060518);
lohi := lohi + fix_mul(dct_in(3), 983521327);
lohi := lohi + fix_mul(dct_in(6), 138952416);
lohi := lohi + fix_mul(dct_in(9), -1055448391);
lohi := lohi + fix_mul(dct_in(12), 407387872);
lohi := lohi + fix_mul(dct_in(15), 844568910);
res := lohi;
rawout(11) := rawout(11) + res; -- fix_mul(res, window(11));

lohi := fix_mul(dct_in(0), -844568910);
lohi := lohi + fix_mul(dct_in(1), 85318785);
lohi := lohi + fix_mul(dct_in(3), 407387872);
lohi := lohi + fix_mul(dct_in(4), -129483039);
lohi := lohi + fix_mul(dct_in(6), 1055448391);
lohi := lohi + fix_mul(dct_in(7), -18293432);
lohi := lohi + fix_mul(dct_in(9), 138952416);
lohi := lohi + fix_mul(dct_in(10), 138952416);
lohi := lohi + fix_mul(dct_in(12), -983521327);
lohi := lohi + fix_mul(dct_in(13), -53633630);
lohi := lohi + fix_mul(dct_in(15), -648060518);
lohi := lohi + fix_mul(dct_in(16), -111189606);
res := lohi;
rawout(12) :=rawout(12) + res; -- fix_mul(res, window(12));

lohi := fix_mul(dct_in(0), -916495974);
lohi := lohi + fix_mul(dct_in(1), 157245849);
lohi := lohi + fix_mul(dct_in(3), -379625062);
lohi := lohi + fix_mul(dct_in(4), -379625062);
lohi := lohi + fix_mul(dct_in(6), 379625062);
lohi := lohi + fix_mul(dct_in(7), 379625062);
lohi := lohi + fix_mul(dct_in(9), 916495974);
lohi := lohi + fix_mul(dct_in(10), -157245849);
lohi := lohi + fix_mul(dct_in(12), 916495974);
lohi := lohi + fix_mul(dct_in(13), -157245849);
lohi := lohi + fix_mul(dct_in(15), 379625062);
lohi := lohi + fix_mul(dct_in(16), 379625062);
res := lohi;
rawout(13) := rawout (13) + res; -- fix_mul(res, window(13));

lohi := fix_mul(dct_in(0), -844568910);
lohi := lohi + fix_mul(dct_in(1), 85318785);
lohi := lohi + fix_mul(dct_in(3), -787012935);
lohi := lohi + fix_mul(dct_in(4), -250142023);
lohi := lohi + fix_mul(dct_in(6), -675823328);
lohi := lohi + fix_mul(dct_in(7), 397918495);
lohi := lohi + fix_mul(dct_in(9), -518577479);
lohi := lohi + fix_mul(dct_in(10), -518577479);
lohi := lohi + fix_mul(dct_in(12), -325991431);
lohi := lohi + fix_mul(dct_in(13), 603896265);
lohi := lohi + fix_mul(dct_in(15), -111189606);
lohi := lohi + fix_mul(dct_in(16), -648060518);
res := lohi;
rawout(14) :=rawout(14) + res; -- fix_mul(res, window(14));

lohi := fix_mul(dct_in(0), -648060518);
lohi := lohi + fix_mul(dct_in(1), -111189606);
lohi := lohi + fix_mul(dct_in(3), -603896265);
lohi := lohi + fix_mul(dct_in(4), 325991431);
lohi := lohi + fix_mul(dct_in(6), -518577479);
lohi := lohi + fix_mul(dct_in(7), -518577479);
lohi := lohi + fix_mul(dct_in(9), -397918495);
lohi := lohi + fix_mul(dct_in(10), 675823328);
lohi := lohi + fix_mul(dct_in(12), -250142023);
lohi := lohi + fix_mul(dct_in(13), -787012935);
lohi := lohi + fix_mul(dct_in(15), -85318785);
lohi := lohi + fix_mul(dct_in(16), 844568910);
res := lohi;
rawout(15) :=rawout(15) + res; -- fix_mul(res, window(15));

lohi := fix_mul(dct_in(0), -379625062);
lohi := lohi + fix_mul(dct_in(1), -379625062);
lohi := lohi + fix_mul(dct_in(3), -157245849);
lohi := lohi + fix_mul(dct_in(4), 916495974);
lohi := lohi + fix_mul(dct_in(6), 157245849);
lohi := lohi + fix_mul(dct_in(7), -916495974);
lohi := lohi + fix_mul(dct_in(9), 379625062);
lohi := lohi + fix_mul(dct_in(10), 379625062);
lohi := lohi + fix_mul(dct_in(12), 379625062);
lohi := lohi + fix_mul(dct_in(13), 379625062);
lohi := lohi + fix_mul(dct_in(15), 157245849);
lohi := lohi + fix_mul(dct_in(16), -916495974);
res := lohi;
rawout(16) :=rawout (16) +  res; -- fix_mul(res, window(16));

lohi := fix_mul(dct_in(0), -111189606);
lohi := lohi + fix_mul(dct_in(1), -648060518);
lohi := lohi + fix_mul(dct_in(3), 53633630);
lohi := lohi + fix_mul(dct_in(4), 983521327);
lohi := lohi + fix_mul(dct_in(6), 138952416);
lohi := lohi + fix_mul(dct_in(7), 138952416);
lohi := lohi + fix_mul(dct_in(9), 18293432);
lohi := lohi + fix_mul(dct_in(10), -1055448391);
lohi := lohi + fix_mul(dct_in(12), -129483039);
lohi := lohi + fix_mul(dct_in(13), 407387872);
lohi := lohi + fix_mul(dct_in(15), -85318785);
lohi := lohi + fix_mul(dct_in(16), 844568910);
res := lohi;
rawout(17) :=rawout(17) + res; -- fix_mul(res, window(17));

lohi := fix_mul(dct_in(1), -844568910);
lohi := lohi + fix_mul(dct_in(2), 85318785);
lohi := lohi + fix_mul(dct_in(4), 407387872);
lohi := lohi + fix_mul(dct_in(5), -129483039);
lohi := lohi + fix_mul(dct_in(7), 1055448391);
lohi := lohi + fix_mul(dct_in(8), -18293432);
lohi := lohi + fix_mul(dct_in(10), 138952416);
lohi := lohi + fix_mul(dct_in(11), 138952416);
lohi := lohi + fix_mul(dct_in(13), -983521327);
lohi := lohi + fix_mul(dct_in(14), -53633630);
lohi := lohi + fix_mul(dct_in(16), -648060518);
lohi := lohi + fix_mul(dct_in(17), -111189606);
res := lohi;
rawout(18) := rawout (18) + res; -- fix_mul(res, window(18));

lohi := fix_mul(dct_in(1), -916495974);
lohi := lohi + fix_mul(dct_in(2), 157245849);
lohi := lohi + fix_mul(dct_in(4), -379625062);
lohi := lohi + fix_mul(dct_in(5), -379625062);
lohi := lohi + fix_mul(dct_in(7), 379625062);
lohi := lohi + fix_mul(dct_in(8), 379625062);
lohi := lohi + fix_mul(dct_in(10), 916495974);
lohi := lohi + fix_mul(dct_in(11), -157245849);
lohi := lohi + fix_mul(dct_in(13), 916495974);
lohi := lohi + fix_mul(dct_in(14), -157245849);
lohi := lohi + fix_mul(dct_in(16), 379625062);
lohi := lohi + fix_mul(dct_in(17), 379625062);
res := lohi;
rawout(19) := rawout (19) + res; -- fix_mul(res, window(19));

lohi := fix_mul(dct_in(1), -844568910);
lohi := lohi + fix_mul(dct_in(2), 85318785);
lohi := lohi + fix_mul(dct_in(4), -787012935);
lohi := lohi + fix_mul(dct_in(5), -250142023);
lohi := lohi + fix_mul(dct_in(7), -675823328);
lohi := lohi + fix_mul(dct_in(8), 397918495);
lohi := lohi + fix_mul(dct_in(10), -518577479);
lohi := lohi + fix_mul(dct_in(11), -518577479);
lohi := lohi + fix_mul(dct_in(13), -325991431);
lohi := lohi + fix_mul(dct_in(14), 603896265);
lohi := lohi + fix_mul(dct_in(16), -111189606);
lohi := lohi + fix_mul(dct_in(17), -648060518);
res := lohi;
rawout(20) := rawout(20) + res; -- fix_mul(res, window(20));

lohi := fix_mul(dct_in(1), -648060518);
lohi := lohi + fix_mul(dct_in(2), -111189606);
lohi := lohi + fix_mul(dct_in(4), -603896265);
lohi := lohi + fix_mul(dct_in(5), 325991431);
lohi := lohi + fix_mul(dct_in(7), -518577479);
lohi := lohi + fix_mul(dct_in(8), -518577479);
lohi := lohi + fix_mul(dct_in(10), -397918495);
lohi := lohi + fix_mul(dct_in(11), 675823328);
lohi := lohi + fix_mul(dct_in(13), -250142023);
lohi := lohi + fix_mul(dct_in(14), -787012935);
lohi := lohi + fix_mul(dct_in(16), -85318785);
lohi := lohi + fix_mul(dct_in(17), 844568910);
res := lohi;
rawout(21) := rawout(21) + res; -- fix_mul(res, window(21));

lohi := fix_mul(dct_in(1), -379625062);
lohi := lohi + fix_mul(dct_in(2), -379625062);
lohi := lohi + fix_mul(dct_in(4), -157245849);
lohi := lohi + fix_mul(dct_in(5), 916495974);
lohi := lohi + fix_mul(dct_in(7), 157245849);
lohi := lohi + fix_mul(dct_in(8), -916495974);
lohi := lohi + fix_mul(dct_in(10), 379625062);
lohi := lohi + fix_mul(dct_in(11), 379625062);
lohi := lohi + fix_mul(dct_in(13), 379625062);
lohi := lohi + fix_mul(dct_in(14), 379625062);
lohi := lohi + fix_mul(dct_in(16), 157245849);
lohi := lohi + fix_mul(dct_in(17), -916495974);
res := lohi;
rawout(22) := rawout(22) + res; -- fix_mul(res, window(22));

lohi := fix_mul(dct_in(1), -111189606);
lohi := lohi + fix_mul(dct_in(2), -648060518);
lohi := lohi + fix_mul(dct_in(4), 53633630);
lohi := lohi + fix_mul(dct_in(5), 983521327);
lohi := lohi + fix_mul(dct_in(7), 138952416);
lohi := lohi + fix_mul(dct_in(8), 138952416);
lohi := lohi + fix_mul(dct_in(10), 18293432);
lohi := lohi + fix_mul(dct_in(11), -1055448391);
lohi := lohi + fix_mul(dct_in(13), -129483039);
lohi := lohi + fix_mul(dct_in(14), 407387872);
lohi := lohi + fix_mul(dct_in(16), -85318785);
lohi := lohi + fix_mul(dct_in(17), 844568910);
res := lohi;
rawout(23) := rawout(23) + res; -- fix_mul(res, window(23));

lohi := fix_mul(dct_in(2), -844568910);
lohi := lohi + fix_mul(dct_in(5), 407387872);
lohi := lohi + fix_mul(dct_in(8), 1055448391);
lohi := lohi + fix_mul(dct_in(11), 138952416);
lohi := lohi + fix_mul(dct_in(14), -983521327);
lohi := lohi + fix_mul(dct_in(17), -648060518);
res := lohi;
rawout(24) :=rawout(24) + res; -- fix_mul(res, window(24));

lohi := fix_mul(dct_in(2), -916495974);
lohi := lohi + fix_mul(dct_in(5), -379625062);
lohi := lohi + fix_mul(dct_in(8), 379625062);
lohi := lohi + fix_mul(dct_in(11), 916495974);
lohi := lohi + fix_mul(dct_in(14), 916495974);
lohi := lohi + fix_mul(dct_in(17), 379625062);
res := lohi;
rawout(25) := rawout(25) + res; -- fix_mul(res, window(25));

lohi := fix_mul(dct_in(2), -844568910);
lohi := lohi + fix_mul(dct_in(5), -787012935);
lohi := lohi + fix_mul(dct_in(8), -675823328);
lohi := lohi + fix_mul(dct_in(11), -518577479);
lohi := lohi + fix_mul(dct_in(14), -325991431);
lohi := lohi + fix_mul(dct_in(17), -111189606);
res := lohi;
rawout(26) :=rawout(26) + res; -- fix_mul(res, window(26));

lohi := fix_mul(dct_in(2), -648060518);
lohi := lohi + fix_mul(dct_in(5), -603896265);
lohi := lohi + fix_mul(dct_in(8), -518577479);
lohi := lohi + fix_mul(dct_in(11), -397918495);
lohi := lohi + fix_mul(dct_in(14), -250142023);
lohi := lohi + fix_mul(dct_in(17), -85318785);
res := lohi;
rawout(27) := rawout(27) + res; -- fix_mul(res, window(27));

lohi := fix_mul(dct_in(2), -379625062);
lohi := lohi + fix_mul(dct_in(5), -157245849);
lohi := lohi + fix_mul(dct_in(8), 157245849);
lohi := lohi + fix_mul(dct_in(11), 379625062);
lohi := lohi + fix_mul(dct_in(14), 379625062);
lohi := lohi + fix_mul(dct_in(17), 157245849);
res := lohi;
rawout(28) := rawout (28) + res; -- fix_mul(res, window(28));

lohi := fix_mul(dct_in(2), -111189606);
lohi := lohi + fix_mul(dct_in(5), 53633630);
lohi := lohi + fix_mul(dct_in(8), 138952416);
lohi := lohi + fix_mul(dct_in(11), 18293432);
lohi := lohi + fix_mul(dct_in(14), -129483039);
lohi := lohi + fix_mul(dct_in(17), -85318785);
res := lohi;
rawout(29) :=rawout(29) + res; -- fix_mul(res, window(29));


dct_out(0 ) <= prev_line_in(0) + rawout(0);
prev_line_out(0) <= rawout(18);
dct_out(1) <= prev_line_in(1) + rawout(1);
prev_line_out(1) <= rawout(19);
dct_out(2) <= prev_line_in(2) + rawout(2);
prev_line_out(2) <= rawout(20);
dct_out(3) <= prev_line_in(3) + rawout(3);
prev_line_out(3) <= rawout(21);
dct_out(4) <= prev_line_in(4) + rawout(4);
prev_line_out(4) <= rawout(22);
dct_out(5) <= prev_line_in(5) + rawout(5);
prev_line_out(5) <= rawout(23);
dct_out(6) <= prev_line_in(6) + rawout(6);
prev_line_out(6) <= rawout(24);
dct_out(7) <= prev_line_in(7) + rawout(7);
prev_line_out(7) <= rawout(25);
dct_out(8) <= prev_line_in(8) + rawout(8);
prev_line_out(8) <= rawout(26);
dct_out(9) <= prev_line_in(9) + rawout(9);
prev_line_out(9) <= rawout(27);
dct_out(10) <= prev_line_in(10) + rawout(10);
prev_line_out(10) <= rawout(28);
dct_out(11) <= prev_line_in(11) + rawout(11);
prev_line_out(11) <= rawout(29);
dct_out(12) <= prev_line_in(12) + rawout(12);
prev_line_out(12) <= rawout(30);
dct_out(13) <= prev_line_in(13) + rawout(13);
prev_line_out(13) <= rawout(31);
dct_out(14) <= prev_line_in(14) + rawout(14);
prev_line_out(14) <= rawout(32);
dct_out(15) <= prev_line_in(15) + rawout(15);
prev_line_out(15) <= rawout(33);
dct_out(16) <= prev_line_in(16) + rawout(16);
prev_line_out(16) <= rawout(34);
dct_out(17) <= prev_line_in(17) + rawout(17);
prev_line_out(17) <= rawout(35);


end process;

end behavioral;
