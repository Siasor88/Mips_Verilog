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

	# F[3] = F[1] / F[2]
	div.s $f3,$f1,$f2
	nop
	nop
	nop
	nop

	# F[4] = F[2] / F[1]
	div.s $f4,$f2,$f1
	nop
	nop
	nop
	nop

	# F[5] = round(F[3])
	# F[6] = round(F[4])
	round.w.s $f5,$f3
	nop
	nop
	nop
	round.w.s $f6,$f4
	nop
	nop
	nop
	nop

	# R[5] = F[5]
	# R[6] = F[6]
	mfc1 $5,$f5
	nop
	nop
	nop
	mfc1 $6,$f6
	nop
	nop
	nop
	nop

	# R[7] = R[6] - R[5]
	sub $7,$6,$5
	nop
	nop
	nop
	nop
	blez $7,five_bg_six
	nop
	nop
	nop
	nop
	# result = R[6]
	syscall
five_bg_six:
	add	$6,$5,$0
	nop
	nop
	nop
	nop
	syscall
