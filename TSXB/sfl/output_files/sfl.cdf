/* Quartus II 32-bit Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(EPM3128A) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(EP2C8Q208) Path("D:/VCS/Hg/FPGA/TSXB/sfl/output_files/") File("sfl.sof") MfrSpec(OpMask(1) SEC_Device(EPCS4) Child_OpMask(1 1) SFLPath("D:/VCS/Hg/FPGA/TSXB/fpga_kick/output_files/fpga_kick.jic"));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
