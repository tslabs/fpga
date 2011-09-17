library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use std.textio.all;

PACKAGE mul is

function fix_mul( a , b : integer ) return integer;
function fix_mul( a: std_logic_vector ; b : integer ) return std_logic_vector;

function divide(a, b : integer) return integer;
function divide(a, b : std_logic_vector) return std_logic_vector;

end mul;




PACKAGE BODY mul IS

function  fix_mul( a , b : integer ) return integer IS  
	variable vector_a, vector_b : std_logic_vector(31 downto 0);
	variable vector_result : std_logic_vector(63 downto 0);
	VARIABLE  result : integer;
begin
	vector_a := conv_std_logic_vector(a, 32);
	vector_b := conv_std_logic_vector(b, 32);
	vector_result := vector_a * vector_b;
	result := conv_integer(vector_result(61 downto 30));
	
	return result;
end;



function  fix_mul( a:std_logic_vector ; b : integer ) return std_logic_vector IS  

VARIABLE  v_mul,v_mul0 : std_logic_vector (31 downto 0);
VARIABLE  v_mul1 : std_logic_vector(63 downto 0);

begin

 v_mul0 := conv_std_logic_vector (b,32);
 v_mul1 := a* v_mul0;
 v_mul(31 downto 0) := v_mul1 ( 61 downto 30);

return v_mul;
end;


function divide(a, b: integer) return integer is
	variable vector_a, vector_b, vector_result : std_logic_vector(31 downto 0);
begin
	vector_a := conv_std_logic_vector(a, 32);
	vector_b := conv_std_logic_vector(b, 32);
	vector_result := divide(vector_a, vector_b);

	return conv_integer(vector_result);
end;


function divide(a, b : std_logic_vector) return std_logic_vector is					-- 32 bits integer divider using Booth Algorithm
	variable partial_remainder, quotient : std_logic_vector(31 downto 0);
	variable zeros : std_logic_vector(30 downto 0);
begin
	zeros := (others=>'0');
	partial_remainder := zeros & a(31);
	for i in 31 downto 0 loop
		if partial_remainder>=b then
			quotient(i):='1';
			partial_remainder:=partial_remainder-b;
		else
			quotient(i):='0';
		end if;
		if i/=0 then
			partial_remainder:=partial_remainder(30 downto 0) & a(i-1);
		end if;
	end loop;

	return quotient;
end;


end mul;
