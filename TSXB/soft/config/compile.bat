
set PRJ=tsxb

sjasmplus.exe --lst=%PRJ%.lst %PRJ%.asm
spgbld.exe -b tsxb.ini tsxb.spg

pause
