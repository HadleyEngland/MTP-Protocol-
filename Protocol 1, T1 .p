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
I1 = 3
__LightIntensity=<I1>
;_____________________________________________________________________________________________________________
;There is a pre-illumination phase with only far red light, followed by determination of Fo and Fm
<0s>=>SET_FILTER(CHL)
Preillumination=10s
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
<Fmstart - TS>=>SI_Act2(I1)
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
;
<ALstart1 - TS>=>SI_Act2(I1)
;
ALstart = <ALstart1>
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
PulseL - TS=> SI_Act2(I1)
PulseL=>SatPulse(PulseDuration)
PulseL#<200ms, 200ms + mfmsub_length .. PulseDuration-mfmsub_length>=>mfmsub
;
Last = ALstart1+ALduration+2*mfmsub_length
Last + <0s, 1s .. 5s>=>mfmsub
;--------------------------------------------------------------
;
<ALstart1 + PulseLStart + PulseDuration/2>=>checkPoint,"startFm_Lss1"
<ALstart1 + PulseLStart + PulseDuration - mfmsub_length>=>checkPoint,"endFm_Lss1"
;
;
;******************* Ft' definition **********************************
;
<ALstart1 + PulseLStart - PulseDuration>=>checkPoint,"startFt_Lss1"
<ALstart1 + PulseLStart - PulseDuration/2 + mfmsub_length>=>checkPoint,"endFt_Lss1"
;
;END ******************************************************************