/* Quartus II 32-bit Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(EPM3128AT100) MfrSpec(OpMask(0) FullPath("D:/VCS/Hg/FPGA/TSXB/cpld/tsxb_cpld.pof"));
	P ActionCode(Cfg)
		Device PartName(EP2C8Q208) Path("D:/VCS/Hg/FPGA/TSXB/fpga_kick/output_files/") File("fpga_kick.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
