.global main
main:
		# First PMU register address
		li	t5, 0xfff5100000;
		# Write b10 to config register to reset and stop counter
		li	t3, 0x2;
		sd  t3, 0(t5);
		
		jal   exit