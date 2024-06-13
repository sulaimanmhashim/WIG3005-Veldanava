class_name PlayerStats

var Level :int
var EXP :float
var SkillPoint :int

var HP :int
var MP :int
var ATK :int
var DEF :int
var INT :int
var WIS :int

func _init():
	EXP = 0
	levelUP(EXP)

func levelUP(EXP):
	if EXP ==0:
		Level=1
	else:
		var exp_check = pow((4.0*EXP)/5.0 , 1.0/3.0)
		if exp_check/(Level+1)>=1:
			Level+=1
		
	HP = 50*Level
	MP = 50*Level
	ATK = 10*Level
	DEF = 10*Level
	INT = 10*Level
	WIS = 10*Level

func gainEXP(EXPGain:float):
	EXP+=EXPGain
	levelUP(EXP)

func skillInvest(statName):
	match statName:
		"HP":
			HP=HP+300
		"MP":
			MP=MP+300
		"ATK":
			ATK = ATK+60
		"DEF":
			DEF = DEF+60
		"DEF":
			DEF = DEF+60
		"INT":
			INT = INT+60
		"WIS":
			WIS = WIS+60
		_:
			print("error")
