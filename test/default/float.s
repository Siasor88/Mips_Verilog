.text
main:
	# R[5] = 0x41b0f5c3
	lui $5,0x41b0
	nop
	nop
	nop
	nop
	ori $5,$5,0xf5c3
	nop
	nop
	nop
	nop

	# F[1] = R[5] = 0x41b0f5c3 = 22.12
	mtc1 $5,$f1
	nop
	nop
	nop
	nop

	# R[6] = 0x42055c29
	lui $6,0x4205
	nop
	nop
	nop
	nop
	ori $6,$6,0x5c29
	nop
	nop
	nop
	nop

	# F[2] = R[6] = 0x42055c29 = 33.34
	mtc1 $6,$f2
	nop
	nop
	nop
	nop

	# F[3] = F[2] - F[1] = 33.34 - 22.12 = 0x4133851f = 11.22
	sub.s $f3,$f2,$f1
	nop
	nop
	nop
	nop

	# F[4] = F[2] + F[1] = 0x425dd70a = 55.46
	add.s $f4,$f2,$f1
	nop
	nop
	nop
	nop

	# F[5] = F[1] * F[2] = 0x44385ec5 = 737.4808
	mul.s $f5,$f1,$f2
	nop
	nop
	nop
	nop

	# F[6] = F[4] / F[1] = 0x40207683 = 2.50723327306
	div.s $f6,$f4,$f1
	nop
	nop
	nop
	nop

	# F[7] = -F[2] = 0xc2055c29 = -33.34
	neg.s $f7,$f2
	nop
	nop
	nop
	nop

	# F[8] = round(F[6]) = 0x00000003 = 3
	round.w.s $f8,$f6
	nop
	nop
	nop
	nop

	# F[10] = F[2] + 0 = 0x42055c29 = 33.34
	# F[12] = F[2] == F[10] = 0x00000001 = 1
	add.s $f10,$f2,$f0
	nop
	nop
	nop
	nop
	add.d $f12,$f2,$f10
	nop
	nop
	nop
	nop

	# F[14] = F[6] <= F[2] = 0x00000001 = 1
	# F[16] = F[4] <= F[2] = 0x00000000 = 0
	sub.d $f14,$f6,$f2
	nop
	nop
	nop
	nop
	sub.d $f16,$f4,$f2
	nop
	nop
	nop
	nop


	syscall
