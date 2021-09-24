.global main
main:
		# First PMU register address
		li	t5, 0xfff5100000;
		# Read config register and cycles counter
		ld	t0, 0(t5);
		ld	t1, 8(t5);
		
		jal   exit