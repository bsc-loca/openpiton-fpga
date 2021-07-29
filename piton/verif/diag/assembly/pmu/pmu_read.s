.global main
main:
		# First PMU register address
		li	t5, 0xfff5100000;
		# Read config register and cycles counter
		ld	t0, 184(t5);
		ld	t1, 0(t5);
		
		jal   exit