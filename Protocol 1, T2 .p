TS=50ms
;Rapid light curve in Actinic light 2 for TOMI-2
;version November 11, 2020
;with FilterWheel
;high-resolution CCD - TOMI-2
;estimated time: app. 372 s
;for successful measurement check Light curve settings manual
ADD2=20
ADD1=0
Act2=3
Act1=0
;
include default.inc  ;Includes standard options, do not remove it !
include light.inc  ;Includes standard options, do not remove it !
include FW.inc  ;Includes standard options, do not remove it !

Shutter=1
Sensitivity=61.4
Super=50


__LightA=24.122
__LightB=-61.463

;3 = 10.903
;4 = 35.025
;5 = 59.147
;6 = 83.269
;7 = 107.391
;8 = 131.513
;9 = 155.635
;10 = 179.757
;15 = 300.367
;20 = 420.977
;25 = 541.587
;30 = 662.197
;35 = 782.807
;40 = 903.417

;These are the light intensities used for the Rapid light curve
I1 = 5
I2 = 10
I3 = 15
I4 = 20
I5 = 25
I6 = 30
I7 = 35
I8 = 40
I9 = 45
I10 = 55
I11 = 65
I12 = 75
I13 = 85
I14 = 90
I15 = 95


__LightIntensity=<I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15>
;_____________________________________________________________________________________________________________
;There is a pre-illumination phase with only far red light, followed by determination of Fo and Fm
<0s>=>SET_FILTER(CHL)
Preillumination=440s
<0s>=>act2(Preillumination)
start = Preillumination;
;-------------------------------------------------------------------------------------------------------------
;*** Fo Measurement ******************************************************************************************
;-------------------------------------------------------------------------------------------------------------
F0duration = 5s
F0measure = 1s
start + <0,F0measure..F0duration>=>mfmsub
start + <0s>=>checkPoint,"startFo"
start + <F0duration - F0measure>=>checkPoint,"endFo"
;
;-------------------------------------------------------------------------------------------------------------
;*** Saturating Pulse & Fm Measurement ***********************************************************************
;-------------------------------------------------------------------------------------------------------------
PulseDuration = 800ms;
Fmstart = start + F0duration+mfmsub_length
;
<Fmstart - TS>=>SI_Act2(I15)
<Fmstart>=>SatPulse(PulseDuration)
<Fmstart>=>act2(PulseDuration)
Fmstart+<200ms, 200ms + mfmsub_length .. PulseDuration-mfmsub_length>=>mfmsub
;
<Fmstart + PulseDuration/2>=>checkPoint,"startFm"
<Fmstart + PulseDuration - mfmsub_length>=>checkPoint,"endFm"
<Fmstart + PulseDuration/3>=>checkPoint,"timeVisual"
;
;*** Actinic light Exposure *******************************
Pause = 2*TS
ALduration = 30s
ALmeasure = ALduration/6         
;Protocol contains 5 minutes of illumination with low light in order to keep photosynthesis active while samples are brogth to target temperatures by the thermocycler
ALstart1 = Fmstart + PulseDuration + Pause 
ALstart2 = ALstart1 + ALduration + Pause 
ALstart3 = ALstart2 + ALduration + Pause 
ALstart4 = ALstart3 + ALduration + Pause 
ALstart5 = ALstart4 + ALduration + Pause 
ALstart6 = ALstart5 + ALduration + Pause 
ALstart7 = ALstart6 + ALduration + Pause
ALstart8 = ALstart7 + ALduration + Pause
ALstart9 = ALstart8 + ALduration + Pause
ALstart10 = ALstart9 + ALduration + Pause
ALstart11 = ALstart10 + ALduration + Pause
ALstart12 = ALstart11 + ALduration + Pause
ALstart13 = ALstart12 + ALduration + Pause
ALstart14 = ALstart13 + ALduration + Pause
ALstart15 = ALstart14 + ALduration + Pause

;
<ALstart1 - TS>=>SI_Act2(I1)
<ALstart2 - TS>=>SI_Act2(I2)
<ALstart3 - TS>=>SI_Act2(I3)
<ALstart4 - TS>=>SI_Act2(I4)
<ALstart5 - TS>=>SI_Act2(I5)
<ALstart6 - TS>=>SI_Act2(I6)
<ALstart7 - TS>=>SI_Act2(I7)
<ALstart8 - TS>=>SI_Act2(I8)
<ALstart9 - TS>=>SI_Act2(I9)
<ALstart10 - TS>=>SI_Act2(I10)
<ALstart11 - TS>=>SI_Act2(I11)
<ALstart12 - TS>=>SI_Act2(I12)
<ALstart13 - TS>=>SI_Act2(I13)
<ALstart14 - TS>=>SI_Act2(I14)
<ALstart15 - TS>=>SI_Act2(I15)

;
ALstart = <ALstart1, ALstart2, ALstart3, ALstart4, ALstart5, ALstart6, ALstart7, ALstart8, ALstart9, ALstart10, ALstart11, ALstart12, ALstart13, ALstart14, ALstart15>
ALstart => act2(ALduration)
;
;******* Kautsky Effect Measurement **********************************
;
;ALstart + TS => mfmsub
ALstart#<TS, TS + ALmeasure ..ALduration-2*PulseDuration>=>mfmsub
;
;******************* Ft'& Fm' definition **********************************
PulseLStart = ALduration - PulseDuration - mfmsub_length
;
FtL = ALstart + PulseLStart - PulseDuration
FtL#<TS, TS+mfmsub_length..PulseDuration/2>=>mfmsub
;
PulseL = ALstart + PulseLStart
PulseL - TS=> SI_Act2(I15)
PulseL=>SatPulse(PulseDuration)
PulseL#<200ms, 200ms + mfmsub_length .. PulseDuration-mfmsub_length>=>mfmsub
;
Last = ALstart15+ALduration+2*mfmsub_length
Last + <0s, 1s .. 5s>=>mfmsub
;--------------------------------------------------------------
;
<ALstart1 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss1"
<ALstart1 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss1"
;
<ALstart2 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss2"
<ALstart2 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss2"
;
<ALstart3 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss3"
<ALstart3 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss3"
;
<ALstart4 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss4"
<ALstart4 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss4"
;
<ALstart5 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss5"
<ALstart5 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss5"
;
<ALstart6 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss6"
<ALstart6 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss6"
;
<ALstart7 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss7"
<ALstart7 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss7"
;
<ALstart8 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss8"
<ALstart8 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss8"
;
<ALstart9 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss9"
<ALstart9 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss9"
;
<ALstart10 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss10"
<ALstart10 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss10"
;
<ALstart11 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss11"
<ALstart11 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss11"
;
<ALstart12 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss12"
<ALstart12 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss12"
;
<ALstart13 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss13"
<ALstart13 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss13"
;
<ALstart14 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss14"
<ALstart14 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss14"
;
<ALstart15 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss15"
<ALstart15 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss15"
;
;******************* Ft' definition **********************************
;
<ALstart1 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss1"
<ALstart1 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss1"
;
<ALstart2 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss2"
<ALstart2 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss2"
;
<ALstart3 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss3"
<ALstart3 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss3"
;
<ALstart4 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss4"
<ALstart4 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss4"
;
<ALstart5 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss5"
<ALstart5 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss5"
;
<ALstart6 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss6"
<ALstart6 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss6"
;
<ALstart7 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss7"
<ALstart7 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss7"
;
<ALstart8 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss8"
<ALstart8 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss8"
;
<ALstart9 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss9"
<ALstart9 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss9"
;
<ALstart10 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss10"
<ALstart10 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss10"
;
<ALstart11 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss11"
<ALstart11 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss11"
;
<ALstart12 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss12"
<ALstart12 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss12"
;
<ALstart13 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss13"
<ALstart13 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss13"
;
<ALstart14 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss14"
<ALstart14 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss14"
;
<ALstart15 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss15"
<ALstart15 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss15"
;
;
;END ******************************************************************