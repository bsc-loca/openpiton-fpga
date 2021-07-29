.global main
main:
		# First PMU register address
		li	t5, 0xfff5100000;
		# Write b10 to reset and stop counter
		li	t3, 0x2;
		# 184 is config register
		sd  t3, 184(t5);
		
		jal   exit