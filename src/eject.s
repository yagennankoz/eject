	.text

B_EJECT:	.macro
	moveq.l	#$4f, d0
	trap	#$0f
	.endm

	jsr	get_args

	tst.b	args_buf
	bne	check_eject
	pea	help_msg
	dc.w	$FF09
	addq.l	#4,sp
	bra	skip3

check_eject:
	btst.b	#0, args_buf
	beq	skip0
	move.w	#$9000, d1
	B_EJECT
skip0:
	btst.b	#1, args_buf
	beq	skip1
	move.w	#$9100, d1
	B_EJECT
skip1:
	btst.b	#2, args_buf
	beq	skip2
	move.w	#$9200, d1
	B_EJECT
skip2:
	btst.b	#3, args_buf
	beq	skip3
	move.w	#$9300, d1
	B_EJECT
skip3:
	dc.w	$FF00


get_args:
	movem.l	d0/a2, rbuf
	clr.b	args_buf

get_args0:
	move.b	(a2)+, d0
	tst.b	d0
	beq	get_args_ret

	cmp.b	#'0', d0
	beq	get_args_set_0
	cmp.b	#'1', d0
	beq	get_args_set_1
	cmp.b	#'2', d0
	beq	get_args_set_2
	cmp.b	#'3', d0
	beq	get_args_set_3

	bra	get_args0

get_args_ret:
	movem.l	rbuf, d0/a2
	rts

get_args_set_0:
	bset.b	#0, args_buf
	bra	get_args0

get_args_set_1:
	bset.b	#1, args_buf
	bra	get_args0

get_args_set_2:
	bset.b	#2, args_buf
	bra	get_args0

get_args_set_3:
	bset.b	#3, args_buf
	bra	get_args0

	.data
help_msg:
	dc.b	'フロッピーディスクをイジェクトします',13,10
	dc.b	'eject [ドライブ番号]',13,10, 13,10
	dc.b	'「eject 01」のようにドライブ番号を列挙できます',13,10, 0

	.bss
rbuf:
	ds.l	3
args_buf:
	ds.b	1

	.end
