clear all

use "/Users/jerrychen/Desktop/uktus15_diary_ep_long.dta"
*open long-format time diary
merge m:1 serial pnum using "/Users/jerrychen/Desktop/uktus15_individual.dta"
*merge with individual data set
drop if _merge==2
*drop unmatched observations
*587632 observations remaining

drop if DVAge <16
drop if DVAge >64
*working age only
*409112 observations remaining

drop if WorkSta==3
drop if WorkSta==4
*full time employed only
*365252 observations remaining

egen PersonID = group(serial pnum)
*5079 individuals in total

gen MergeID = PersonID*2
*even number for merging in later steps

gen Working=1 if whatdoing>=1000 & whatdoing<=1220
gen AtWorkplace=1 if WhereWhen==13
gen WorkingAtWorkplace =1 if Working==1 & AtWorkplace==1
*iditify working at workplace episodes
*(343,348 missing values generated)
*21904 episodes

gen AtHome=1 if WhereWhen==11
gen WorkingAtHome =1 if Working==1 & AtHome==1
*iditify working at home episodes
*(362,074 missing values generated)
*3178 episodes

egen Homeworker = max(WorkingAtHome==1), by(PersonID)
*identify homeworkers

egen Commuter = max(WorkingAtWorkplace==1), by(PersonID)
*identify commuters

gen WorkerStatus= Homeworker+Commuter
gen ExclusiveModel=1 if WorkerStatus==1
gen HybridModel=1 if WorkerStatus==2
gen WorkerStatusUnknown=1 if WorkerStatus==0
*identify worker status (ie exclusively homeworking etc)

drop if WorkerStatusUnknown==1
drop WorkerStatusUnknown
*keeping only individuals with homeworker/commuter categorisation
*227307 observations remaining

gen HourofDay = 4 if tid>=1 & tid<=6
replace HourofDay = 5 if tid>=7 & tid<=12
replace HourofDay = 6 if tid>=13 & tid<=18
replace HourofDay = 7 if tid>=19 & tid<=24
replace HourofDay = 8 if tid>=25 & tid<=30
replace HourofDay = 9 if tid>=31 & tid<=36
replace HourofDay = 10 if tid>=37 & tid<=42
replace HourofDay = 11 if tid>=43 & tid<=48
replace HourofDay = 12 if tid>=49 & tid<=52
replace HourofDay = 13 if tid>=53 & tid<=58
replace HourofDay = 14 if tid>=59 & tid<=64
replace HourofDay = 15 if tid>=65 & tid<=70
replace HourofDay = 16 if tid>=71 & tid<=76
replace HourofDay = 17 if tid>=77 & tid<=82
replace HourofDay = 18 if tid>=83 & tid<=88
replace HourofDay = 19 if tid>=89 & tid<=94
replace HourofDay = 20 if tid>=95 & tid<=100
replace HourofDay = 21 if tid>=101 & tid<=106
replace HourofDay = 22 if tid>=107 & tid<=112
replace HourofDay = 23 if tid>=113 & tid<=118
replace HourofDay = 24 if tid>=119 & tid<=124
replace HourofDay = 1 if tid>=125 & tid<=130
replace HourofDay = 2 if tid>=131 & tid<=136
replace HourofDay = 3 if tid>=137 & tid<=144
*hour of day generated

gen TimeofDay = 1 if HourofDay>=6 & HourofDay<=9
replace TimeofDay =2 if HourofDay>=10 & HourofDay<=12
replace TimeofDay =3 if HourofDay>=12 & HourofDay<=16
replace TimeofDay =4 if HourofDay>=17 & HourofDay<=19
replace TimeofDay =5 if HourofDay>=19 & HourofDay<=22
replace TimeofDay =6 if HourofDay>=22
replace TimeofDay =6 if HourofDay<=5

gen TimeCategory = 1 if whatdoing >=0 & whatdoing<=390
replace TimeCategory = 2 if whatdoing >=1000 & whatdoing<=2210
replace TimeCategory = 3 if whatdoing >=3000 & whatdoing<=4390
replace TimeCategory = 4 if whatdoing >=5000 & whatdoing<=8320
replace TimeCategory = 5 if whatdoing >=9000 & whatdoing<=9890
*Major time categories generated 

gen Duration = eptime/60
gen PersonalDuration = Duration if TimeCategory==1
gen PaidWorkDuration = Duration if TimeCategory==2
gen NonPaidWorkDuration = Duration if TimeCategory==3
gen LeisureDuration = Duration if TimeCategory==4
gen TravelDuration = Duration if TimeCategory==5
*Hourly durations for each major categories generated

gen miniTimeCategory = 1 if whatdoing >=110 & whatdoing<=120
gen Sleep = Duration if miniTimeCategory==1
replace miniTimeCategory = 2 if whatdoing ==210
gen Eating = Duration if miniTimeCategory==2
replace miniTimeCategory = 3 if whatdoing >=1100 & whatdoing<=1120
gen MainJob = Duration if miniTimeCategory==3
replace miniTimeCategory = 4 if whatdoing >=1210 & whatdoing<=1220
gen SecondJob = Duration if miniTimeCategory==4
replace miniTimeCategory = 5 if whatdoing >=2000 & whatdoing<=2210
gen Study = Duration if miniTimeCategory==5
replace miniTimeCategory = 6 if whatdoing >=3100 & whatdoing<=3190
gen FoodManagement = Duration if miniTimeCategory==6
replace miniTimeCategory = 7 if whatdoing >=3200 & whatdoing<=3290
gen HouseUpkeep = Duration if miniTimeCategory==7
replace miniTimeCategory = 8 if whatdoing >=3300 & whatdoing<=3390
gen Laundry = Duration if miniTimeCategory==8
replace miniTimeCategory = 9 if whatdoing >=3410 & whatdoing<=3490
gen Gardening = Duration if miniTimeCategory==9
replace miniTimeCategory = 10 if whatdoing >=3500 & whatdoing<=3590
gen Repair = Duration if miniTimeCategory==10
replace miniTimeCategory = 11 if whatdoing >=3600 & whatdoing<=3690
gen Shopping = Duration if miniTimeCategory==11
replace miniTimeCategory = 12 if whatdoing >=3800 & whatdoing<=3890
gen Childcare = Duration if miniTimeCategory==12
replace miniTimeCategory = 13 if whatdoing >=3900 & whatdoing<=3929
gen Eldercare = Duration if miniTimeCategory==13
replace miniTimeCategory = 14 if whatdoing >=4000 & whatdoing<=4190
gen VolunteerOrganisation = Duration if miniTimeCategory==14
replace miniTimeCategory = 15 if whatdoing >=4200 & whatdoing<=4290
gen InformalHelptoOthers = Duration if miniTimeCategory==15
replace miniTimeCategory = 16 if whatdoing ==4320
gen Religion = Duration if miniTimeCategory==16
replace miniTimeCategory = 17 if whatdoing >=5100 & whatdoing<=5190
gen SocialLife = Duration if miniTimeCategory==17
replace miniTimeCategory = 18 if whatdoing >=5200 & whatdoing<=5299
gen EntertainmentCulture = Duration if miniTimeCategory==18
replace miniTimeCategory = 19 if whatdoing >=6100 & whatdoing<=6190
gen PhysicalExercise = Duration if miniTimeCategory==19
replace miniTimeCategory = 20 if whatdoing >=6200 & whatdoing<=6290
gen ProductiveExercise = Duration if miniTimeCategory==20
replace miniTimeCategory = 21 if whatdoing >=7100 & whatdoing<=7190
gen Arts = Duration if miniTimeCategory==21
replace miniTimeCategory = 22 if whatdoing >=7220 & whatdoing<=7259
gen Computing = Duration if miniTimeCategory==22
replace miniTimeCategory = 23 if whatdoing >=7300 & whatdoing<=7390
gen Gaming = Duration if miniTimeCategory==23
replace miniTimeCategory = 24 if whatdoing >=8100 & whatdoing<=8190
gen Reading = Duration if miniTimeCategory==24
replace miniTimeCategory = 25 if whatdoing >=8210 & whatdoing<=8229
gen TV = Duration if miniTimeCategory==25
replace miniTimeCategory = 26 if whatdoing >=8300 & whatdoing<=8320
gen Radio = Duration if miniTimeCategory==26
replace miniTimeCategory = 27 if whatdoing ==9010
gen TravelPersonal = Duration if miniTimeCategory==27
replace miniTimeCategory = 28 if whatdoing >=9100 & whatdoing<=9130
gen WorkCommute = Duration if miniTimeCategory==28
replace miniTimeCategory = 29 if whatdoing >=9210 & whatdoing<=9230
gen StudyCommute = Duration if miniTimeCategory==29
replace miniTimeCategory = 30 if whatdoing >=9310 & whatdoing<=9440
gen TravelNonpaidWork = Duration if miniTimeCategory==30
replace miniTimeCategory = 31 if whatdoing >=9500 & whatdoing<=9820
gen TravelLeisure = Duration if miniTimeCategory==31
*2-digit level activities generated

egen WorkerID = group(serial pnum)
*3229 workers in total

gen ExclusiveHomeworker=1 if Homeworker==1 & ExclusiveModel==1
egen ExcHWID = group(serial pnum) if ExclusiveHomeworker==1
*Exclusive homeworkers - 297 in total

gen ExclusiveCommuter=1 if Commuter==1 & ExclusiveModel==1
egen ExcCID = group(serial pnum) if ExclusiveCommuter==1
*Exclusive commuters - 2544 in total

gen HybridWorker=1 if HybridModel==1
egen HybridID = group(serial pnum) if HybridWorker==1
*Hybrid workers - 388 in total

gen AnyHomeworker=1 if Homeworker==1
egen AnyHWID = group(serial pnum) if AnyHomeworker==1
*Worker with any episodes working from home - 685 in total (ExclusiveHomeworker & Hybrid)

gen WorkingStatus=1 if ExclusiveHomeworker==1
replace WorkingStatus=2 if ExclusiveCommuter==1
replace WorkingStatus=3 if HybridWorker==1
*Generate 3 working modes

save "/Users/jerrychen/Desktop/UKTUS15 Treated JECH.dta", replace



*Start generating hourly time use categorical variables
clear all
use "/Users/jerrychen/Desktop/UKTUS15 Treated JECH.dta"

keep if ddayw==1
drop if Enjoy<1
drop if TimeCategory==.
*Only weekday data, with enjoyment data, and time use category samples are retained

gen hour1=1 if HourofDay==1 & TimeCategory==1
replace hour1=2 if HourofDay==1 & TimeCategory==2
replace hour1=3 if HourofDay==1 & TimeCategory==3
replace hour1=4 if HourofDay==1 & TimeCategory==4
replace hour1=5 if HourofDay==1 & TimeCategory==5

gen hour2=1 if HourofDay==2 & TimeCategory==1
replace hour2=2 if HourofDay==2 & TimeCategory==2
replace hour2=3 if HourofDay==2 & TimeCategory==3
replace hour2=4 if HourofDay==2 & TimeCategory==4
replace hour2=5 if HourofDay==2 & TimeCategory==5

gen hour3=1 if HourofDay==3 & TimeCategory==1
replace hour3=2 if HourofDay==3 & TimeCategory==2
replace hour3=3 if HourofDay==3 & TimeCategory==3
replace hour3=4 if HourofDay==3 & TimeCategory==4
replace hour3=5 if HourofDay==3 & TimeCategory==5

gen hour4=1 if HourofDay==4 & TimeCategory==1
replace hour4=2 if HourofDay==4 & TimeCategory==2
replace hour4=3 if HourofDay==4 & TimeCategory==3
replace hour4=4 if HourofDay==4 & TimeCategory==4
replace hour4=5 if HourofDay==4 & TimeCategory==5

gen hour5=1 if HourofDay==5 & TimeCategory==1
replace hour5=2 if HourofDay==5 & TimeCategory==2
replace hour5=3 if HourofDay==5 & TimeCategory==3
replace hour5=4 if HourofDay==5 & TimeCategory==4
replace hour5=5 if HourofDay==5 & TimeCategory==5

gen hour6=1 if HourofDay==6 & TimeCategory==1
replace hour6=2 if HourofDay==6 & TimeCategory==2
replace hour6=3 if HourofDay==6 & TimeCategory==3
replace hour6=4 if HourofDay==6 & TimeCategory==4
replace hour6=5 if HourofDay==6 & TimeCategory==5

gen hour7=1 if HourofDay==7 & TimeCategory==1
replace hour7=2 if HourofDay==7 & TimeCategory==2
replace hour7=3 if HourofDay==7 & TimeCategory==3
replace hour7=4 if HourofDay==7 & TimeCategory==4
replace hour7=5 if HourofDay==7 & TimeCategory==5

gen hour8=1 if HourofDay==8 & TimeCategory==1
replace hour8=2 if HourofDay==8 & TimeCategory==2
replace hour8=3 if HourofDay==8 & TimeCategory==3
replace hour8=4 if HourofDay==8 & TimeCategory==4
replace hour8=5 if HourofDay==8 & TimeCategory==5

gen hour9=1 if HourofDay==9 & TimeCategory==1
replace hour9=2 if HourofDay==9 & TimeCategory==2
replace hour9=3 if HourofDay==9 & TimeCategory==3
replace hour9=4 if HourofDay==9 & TimeCategory==4
replace hour9=5 if HourofDay==9 & TimeCategory==5

gen hour10=1 if HourofDay==10 & TimeCategory==1
replace hour10=2 if HourofDay==10 & TimeCategory==2
replace hour10=3 if HourofDay==10 & TimeCategory==3
replace hour10=4 if HourofDay==10 & TimeCategory==4
replace hour10=5 if HourofDay==10 & TimeCategory==5

gen hour11=1 if HourofDay==11 & TimeCategory==1
replace hour11=2 if HourofDay==11 & TimeCategory==2
replace hour11=3 if HourofDay==11 & TimeCategory==3
replace hour11=4 if HourofDay==11 & TimeCategory==4
replace hour11=5 if HourofDay==11 & TimeCategory==5

gen hour12=1 if HourofDay==12 & TimeCategory==1
replace hour12=2 if HourofDay==12 & TimeCategory==2
replace hour12=3 if HourofDay==12 & TimeCategory==3
replace hour12=4 if HourofDay==12 & TimeCategory==4
replace hour12=5 if HourofDay==12 & TimeCategory==5

gen hour13=1 if HourofDay==13 & TimeCategory==1
replace hour13=2 if HourofDay==13 & TimeCategory==2
replace hour13=3 if HourofDay==13 & TimeCategory==3
replace hour13=4 if HourofDay==13 & TimeCategory==4
replace hour13=5 if HourofDay==13 & TimeCategory==5

gen hour14=1 if HourofDay==14 & TimeCategory==1
replace hour14=2 if HourofDay==14 & TimeCategory==2
replace hour14=3 if HourofDay==14 & TimeCategory==3
replace hour14=4 if HourofDay==14 & TimeCategory==4
replace hour14=5 if HourofDay==14 & TimeCategory==5

gen hour15=1 if HourofDay==15 & TimeCategory==1
replace hour15=2 if HourofDay==15 & TimeCategory==2
replace hour15=3 if HourofDay==15 & TimeCategory==3
replace hour15=4 if HourofDay==15 & TimeCategory==4
replace hour15=5 if HourofDay==15 & TimeCategory==5

gen hour16=1 if HourofDay==16 & TimeCategory==1
replace hour16=2 if HourofDay==16 & TimeCategory==2
replace hour16=3 if HourofDay==16 & TimeCategory==3
replace hour16=4 if HourofDay==16 & TimeCategory==4
replace hour16=5 if HourofDay==16 & TimeCategory==5

gen hour17=1 if HourofDay==17 & TimeCategory==1
replace hour17=2 if HourofDay==17 & TimeCategory==2
replace hour17=3 if HourofDay==17 & TimeCategory==3
replace hour17=4 if HourofDay==17 & TimeCategory==4
replace hour17=5 if HourofDay==17 & TimeCategory==5
replace hour17=hour16 if hour17==.

gen hour18=1 if HourofDay==18 & TimeCategory==1
replace hour18=2 if HourofDay==18 & TimeCategory==2
replace hour18=3 if HourofDay==18 & TimeCategory==3
replace hour18=4 if HourofDay==18 & TimeCategory==4
replace hour18=5 if HourofDay==18 & TimeCategory==5

gen hour19=1 if HourofDay==19 & TimeCategory==1
replace hour19=2 if HourofDay==19 & TimeCategory==2
replace hour19=3 if HourofDay==19 & TimeCategory==3
replace hour19=4 if HourofDay==19 & TimeCategory==4
replace hour19=5 if HourofDay==19 & TimeCategory==5

gen hour20=1 if HourofDay==20 & TimeCategory==1
replace hour20=2 if HourofDay==20 & TimeCategory==2
replace hour20=3 if HourofDay==20 & TimeCategory==3
replace hour20=4 if HourofDay==20 & TimeCategory==4
replace hour20=5 if HourofDay==20 & TimeCategory==5

gen hour21=1 if HourofDay==21 & TimeCategory==1
replace hour21=2 if HourofDay==21 & TimeCategory==2
replace hour21=3 if HourofDay==21 & TimeCategory==3
replace hour21=4 if HourofDay==21 & TimeCategory==4
replace hour21=5 if HourofDay==21 & TimeCategory==5

gen hour22=1 if HourofDay==22 & TimeCategory==1
replace hour22=2 if HourofDay==22 & TimeCategory==2
replace hour22=3 if HourofDay==22 & TimeCategory==3
replace hour22=4 if HourofDay==22 & TimeCategory==4
replace hour22=5 if HourofDay==22 & TimeCategory==5

gen hour23=1 if HourofDay==23 & TimeCategory==1
replace hour23=2 if HourofDay==23 & TimeCategory==2
replace hour23=3 if HourofDay==23 & TimeCategory==3
replace hour23=4 if HourofDay==23 & TimeCategory==4
replace hour23=5 if HourofDay==23 & TimeCategory==5

gen hour24=1 if HourofDay==24 & TimeCategory==1
replace hour24=2 if HourofDay==24 & TimeCategory==2
replace hour24=3 if HourofDay==24 & TimeCategory==3
replace hour24=4 if HourofDay==24 & TimeCategory==4
replace hour24=5 if HourofDay==24 & TimeCategory==5

*Wellbeing binary variable for each hour
gen jhour1=1 if HourofDay==1 & Enjoy>=6
replace jhour1=0 if HourofDay==1 & Enjoy<=5

gen jhour2=1 if HourofDay==2 & Enjoy>=6
replace jhour2=0 if HourofDay==2 & Enjoy<=5

gen jhour3=1 if HourofDay==3 & Enjoy>=6
replace jhour3=0 if HourofDay==3 & Enjoy<=5

gen jhour4=1 if HourofDay==4 & Enjoy>=6
replace jhour4=0 if HourofDay==4 & Enjoy<=5

gen jhour5=1 if HourofDay==5 & Enjoy>=6
replace jhour5=0 if HourofDay==5 & Enjoy<=5

gen jhour6=1 if HourofDay==6 & Enjoy>=6
replace jhour6=0 if HourofDay==6 & Enjoy<=5

gen jhour7=1 if HourofDay==7 & Enjoy>=6
replace jhour7=0 if HourofDay==7 & Enjoy<=5

gen jhour8=1 if HourofDay==8 & Enjoy>=6
replace jhour8=0 if HourofDay==8 & Enjoy<=5

gen jhour9=1 if HourofDay==9 & Enjoy>=6
replace jhour9=0 if HourofDay==9 & Enjoy<=5

gen jhour10=1 if HourofDay==10 & Enjoy>=6
replace jhour10=0 if HourofDay==10 & Enjoy<=5

gen jhour11=1 if HourofDay==11 & Enjoy>=6
replace jhour11=0 if HourofDay==11 & Enjoy<=5

gen jhour12=1 if HourofDay==12 & Enjoy>=6
replace jhour12=0 if HourofDay==12 & Enjoy<=5

gen jhour13=1 if HourofDay==13 & Enjoy>=6
replace jhour13=0 if HourofDay==13 & Enjoy<=5

gen jhour14=1 if HourofDay==14 & Enjoy>=6
replace jhour14=0 if HourofDay==14 & Enjoy<=5

gen jhour15=1 if HourofDay==15 & Enjoy>=6
replace jhour15=0 if HourofDay==15 & Enjoy<=5

gen jhour16=1 if HourofDay==16 & Enjoy>=6
replace jhour16=0 if HourofDay==16 & Enjoy<=5

gen jhour17=1 if HourofDay==17 & Enjoy>=6
replace jhour17=0 if HourofDay==17 & Enjoy<=5

gen jhour18=1 if HourofDay==18 & Enjoy>=6
replace jhour18=0 if HourofDay==18 & Enjoy<=5

gen jhour19=1 if HourofDay==19 & Enjoy>=6
replace jhour19=0 if HourofDay==19 & Enjoy<=5

gen jhour20=1 if HourofDay==20 & Enjoy>=6
replace jhour20=0 if HourofDay==20 & Enjoy<=5

gen jhour21=1 if HourofDay==21 & Enjoy>=6
replace jhour21=0 if HourofDay==21 & Enjoy<=5

gen jhour22=1 if HourofDay==22 & Enjoy>=6
replace jhour22=0 if HourofDay==22 & Enjoy<=5

gen jhour23=1 if HourofDay==23 & Enjoy>=6
replace jhour23=0 if HourofDay==23 & Enjoy<=5

gen jhour24=1 if HourofDay==24 & Enjoy>=6
replace jhour24=0 if HourofDay==24 & Enjoy<=5

collapse (mean)PersonID PersonalDuration PaidWorkDuration NonPaidWorkDuration LeisureDuration TravelDuration Enjoy Income DVAge DMSex dhiqual dsoc dgorpaf MarStat NumChild IMonth WorkingStatus (sum)Duration EpisodeCount (lastnm)hour1 (lastnm)hour2 (lastnm)hour3 (lastnm)hour4 (lastnm)hour5 (lastnm)hour6 (lastnm)hour7 (lastnm)hour8 (lastnm)hour9 (lastnm)hour10 (lastnm)hour11 (lastnm)hour12 (lastnm)hour13 (lastnm)hour14 (lastnm)hour15 (lastnm)hour16 (lastnm)hour17 (lastnm)hour18 (lastnm)hour19 (lastnm)hour20 (lastnm)hour21 (lastnm)hour22 (lastnm)hour23 (lastnm)hour24 (lastnm)jhour1 (lastnm)jhour2 (lastnm)jhour3 (lastnm)jhour4 (lastnm)jhour5 (lastnm)jhour6 (lastnm)jhour7 (lastnm)jhour8 (lastnm)jhour9 (lastnm)jhour10 (lastnm)jhour11 (lastnm)jhour12 (lastnm)jhour13 (lastnm)jhour14 (lastnm)jhour15 (lastnm)jhour16 (lastnm)jhour17 (lastnm)jhour18 (lastnm)jhour19 (lastnm)jhour20 (lastnm)jhour21 (lastnm)jhour22 (lastnm)jhour23 (lastnm)jhour24, by(MergeID)

replace hour1=hour24 if hour1==.
replace hour2=hour1 if hour2==.
replace hour3=hour2 if hour3==.
replace hour4=hour3 if hour4==.
replace hour5=hour4 if hour5==.
replace hour6=hour5 if hour6==.
replace hour7=hour6 if hour7==.
replace hour8=hour7 if hour8==.
replace hour9=hour8 if hour9==.
replace hour10=hour9 if hour10==.
replace hour11=hour10 if hour11==.
replace hour12=hour11 if hour12==.
replace hour13=hour12 if hour13==.
replace hour14=hour13 if hour14==.
replace hour15=hour14 if hour15==.
replace hour16=hour15 if hour16==.
replace hour17=hour16 if hour17==.
replace hour18=hour17 if hour18==.
replace hour19=hour18 if hour19==.
replace hour20=hour19 if hour20==.
replace hour21=hour20 if hour21==.
replace hour22=hour21 if hour22==.
replace hour23=hour22 if hour23==.
replace hour24=hour23 if hour24==.
*filling in activities that continue for than one hour

replace hour1=hour24 if hour1==.
replace hour2=hour1 if hour2==.
replace hour3=hour2 if hour3==.
replace hour4=hour3 if hour4==.
replace hour5=hour4 if hour5==.
replace hour6=hour5 if hour6==.
replace hour7=hour6 if hour7==.
replace hour8=hour7 if hour8==.
replace hour9=hour8 if hour9==.
replace hour10=hour9 if hour10==.
replace hour11=hour10 if hour11==.
replace hour12=hour11 if hour12==.
replace hour13=hour12 if hour13==.
replace hour14=hour13 if hour14==.
replace hour15=hour14 if hour15==.
replace hour16=hour15 if hour16==.
replace hour17=hour16 if hour17==.
replace hour18=hour17 if hour18==.
replace hour19=hour18 if hour19==.
replace hour20=hour19 if hour20==.
replace hour21=hour20 if hour21==.
replace hour22=hour21 if hour22==.
replace hour23=hour22 if hour23==.
replace hour24=hour23 if hour24==.
*filling in activities that continue for than one hour

replace jhour1=jhour24 if jhour1==.
replace jhour2=jhour1 if jhour2==.
replace jhour3=jhour2 if jhour3==.
replace jhour4=jhour3 if jhour4==.
replace jhour5=jhour4 if jhour5==.
replace jhour6=jhour5 if jhour6==.
replace jhour7=jhour6 if jhour7==.
replace jhour8=jhour7 if jhour8==.
replace jhour9=jhour8 if jhour9==.
replace jhour10=jhour9 if jhour10==.
replace jhour11=jhour10 if jhour11==.
replace jhour12=jhour11 if jhour12==.
replace jhour13=jhour12 if jhour13==.
replace jhour14=jhour13 if jhour14==.
replace jhour15=jhour14 if jhour15==.
replace jhour16=jhour15 if jhour16==.
replace jhour17=jhour16 if jhour17==.
replace jhour18=jhour17 if jhour18==.
replace jhour19=jhour18 if jhour19==.
replace jhour20=jhour19 if jhour20==.
replace jhour21=jhour20 if jhour21==.
replace jhour22=jhour21 if jhour22==.
replace jhour23=jhour22 if jhour23==.
replace jhour24=jhour23 if jhour24==.
*filling in activities that continue for than one hour

replace jhour1=jhour24 if jhour1==.
replace jhour2=jhour1 if jhour2==.
replace jhour3=jhour2 if jhour3==.
replace jhour4=jhour3 if jhour4==.
replace jhour5=jhour4 if jhour5==.
replace jhour6=jhour5 if jhour6==.
replace jhour7=jhour6 if jhour7==.
replace jhour8=jhour7 if jhour8==.
replace jhour9=jhour8 if jhour9==.
replace jhour10=jhour9 if jhour10==.
replace jhour11=jhour10 if jhour11==.
replace jhour12=jhour11 if jhour12==.
replace jhour13=jhour12 if jhour13==.
replace jhour14=jhour13 if jhour14==.
replace jhour15=jhour14 if jhour15==.
replace jhour16=jhour15 if jhour16==.
replace jhour17=jhour16 if jhour17==.
replace jhour18=jhour17 if jhour18==.
replace jhour19=jhour18 if jhour19==.
replace jhour20=jhour19 if jhour20==.
replace jhour21=jhour20 if jhour21==.
replace jhour22=jhour21 if jhour22==.
replace jhour23=jhour22 if jhour23==.
replace jhour24=jhour23 if jhour24==.
*filling in activities that continue for than one hour

save "/Users/jerrychen/Desktop/UKTUS15 Hourly Variables JECH.dta", replace





*MODULE TO CLEAN AND TREAT 4-WAVE DATA
clear all
use "/Users/jerrychen/Downloads/UKDA-8741-stata/stata/stata13/uk_4wave_caddi_data.dta"

drop if dday>5
*weekday diaries only

drop dev*
drop sec*
drop whoa*
drop whob*
drop whoc*
drop whod*
drop head*
drop ghq*
drop *4wk
drop *dum
drop xday*
drop othr*
drop more*
*dropping irrelevant vars

gen diaryid = mainid*10 + dday
sort diaryid
by diaryid:  gen dup = cond(_N==1,0,_n)
drop if dup>0
reshape long pri loc enj, i(diaryid) j(tid)
*reshaping wide to long

drop if age <16
drop if age >64
*working age only

keep if econstat<5
*full-time employed only

egen PersonID = group(mainid dday)
gen MergeID = PersonID*2+1
*Merge ID for later combination

gen TimeCategory = 1 if pri >=101 & pri<=104
replace TimeCategory = 2 if pri >=117 & pri<=118
replace TimeCategory = 3 if pri >=105 & pri<=110
replace TimeCategory = 3 if pri >=120 & pri <=124
replace TimeCategory = 4 if pri ==119 
replace TimeCategory = 4 if pri >= 125 & pri<=136
replace TimeCategory = 5 if pri >=111 & pri<=116
drop if TimeCategory==.
*Major time categories generated 

gen WorkingAtWorkplace =1 if TimeCategory==2 & loc==202
*iditify working at workplace episodes

gen WorkingAtHome =1 if TimeCategory==2 & loc==201
*iditify working at home episodes

egen Homeworker = max(WorkingAtHome==1), by(mainid)
*identify homeworkers

egen Commuter = max(WorkingAtWorkplace==1), by(mainid)
*identify commuters

gen WorkerStatus= Homeworker+Commuter
gen ExclusiveModel=1 if WorkerStatus==1
gen HybridModel=1 if WorkerStatus==2
gen WorkerStatusUnknown=1 if WorkerStatus==0
*identify worker status (ie exclusively homeworking etc)

drop if WorkerStatusUnknown==1
drop WorkerStatusUnknown
*keeping only individuals with homeworker/commuter categorisation

gen HourofDay = 4 if tid>=1 & tid<=6
replace HourofDay = 5 if tid>=7 & tid<=12
replace HourofDay = 6 if tid>=13 & tid<=18
replace HourofDay = 7 if tid>=19 & tid<=24
replace HourofDay = 8 if tid>=25 & tid<=30
replace HourofDay = 9 if tid>=31 & tid<=36
replace HourofDay = 10 if tid>=37 & tid<=42
replace HourofDay = 11 if tid>=43 & tid<=48
replace HourofDay = 12 if tid>=49 & tid<=52
replace HourofDay = 13 if tid>=53 & tid<=58
replace HourofDay = 14 if tid>=59 & tid<=64
replace HourofDay = 15 if tid>=65 & tid<=70
replace HourofDay = 16 if tid>=71 & tid<=76
replace HourofDay = 17 if tid>=77 & tid<=82
replace HourofDay = 18 if tid>=83 & tid<=88
replace HourofDay = 19 if tid>=89 & tid<=94
replace HourofDay = 20 if tid>=95 & tid<=100
replace HourofDay = 21 if tid>=101 & tid<=106
replace HourofDay = 22 if tid>=107 & tid<=112
replace HourofDay = 23 if tid>=113 & tid<=118
replace HourofDay = 24 if tid>=119 & tid<=124
replace HourofDay = 1 if tid>=125 & tid<=130
replace HourofDay = 2 if tid>=131 & tid<=136
replace HourofDay = 3 if tid>=137 & tid<=144
*hour of day generated

gen ExclusiveHomeworker=1 if Homeworker==1 & ExclusiveModel==1
egen ExcHWID = group(mainid dday) if ExclusiveHomeworker==1
*Exclusive homeworkers 

gen ExclusiveCommuter=1 if Commuter==1 & ExclusiveModel==1
egen ExcCID = group(mainid dday) if ExclusiveCommuter==1
*Exclusive commuters 

gen HybridWorker=1 if HybridModel==1
egen HybridID = group(mainid dday) if HybridWorker==1
*Hybrid workers 

gen AnyHomeworker=1 if Homeworker==1
egen AnyHWID = group(mainid dday) if AnyHomeworker==1
*Worker with any episodes working from home - 685 in total (ExclusiveHomeworker & Hybrid)

gen WorkingStatus=1 if ExclusiveHomeworker==1
replace WorkingStatus=2 if ExclusiveCommuter==1
replace WorkingStatus=3 if HybridWorker==1
*identified three groups of workers

save "/Users/jerrychen/Desktop/Cleaned Long Format UKTUS 16:20.dta", replace

gen Count=1
gen Duration=10
collapse (sum) Duration Count, by(MergeID TimeCategory)

gen PersonalCount=Count if TimeCategory==1
gen PaidWorkCount=Count if TimeCategory==2
gen NonPaidWorkCount=Count if TimeCategory==3
gen LeisureCount=Count if TimeCategory==4
gen TravelCount=Count if TimeCategory==5

gen PDuration=Duration if TimeCategory==1
gen PWDuration=Duration if TimeCategory==2
gen NPWDuration=Duration if TimeCategory==3
gen LDuration=Duration if TimeCategory==4
gen TDuration=Duration if TimeCategory==5

collapse (sum) PersonalCount PaidWorkCount NonPaidWorkCount LeisureCount TravelCount PDuration PWDuration NPWDuration LDuration TDuration, by(MergeID)

gen PersonalDuration=PDuration/60
gen PaidWorkDuration=PWDuration/60
gen NonPaidWorkDuration=NPWDuration/60
gen LeisureDuration=LDuration/60
gen TravelDuration=TDuration/60
gen Duration = PersonalDuration+PaidWorkDuration+NonPaidWorkDuration+LeisureDuration+TravelDuration

save "/Users/jerrychen/Desktop/to merge Count and Duration 16:20.dta", replace
clear

use "/Users/jerrychen/Desktop/Cleaned Long Format UKTUS 16:20.dta"
merge m:1 MergeID using "/Users/jerrychen/Desktop/to merge Count and Duration 16:20.dta"
drop _merge
save "/Users/jerrychen/Desktop/UKTUS 4-wave Treated JECH", replace

*generate hourly variables
clear all
use "/Users/jerrychen/Desktop/UKTUS 4-wave Treated JECH"

gen Duration = PersonalDuration +PaidWorkDuration +NonPaidWorkDuration +LeisureDuration +TravelDuration

gen hour1=1 if HourofDay==1 & TimeCategory==1
replace hour1=2 if HourofDay==1 & TimeCategory==2
replace hour1=3 if HourofDay==1 & TimeCategory==3
replace hour1=4 if HourofDay==1 & TimeCategory==4
replace hour1=5 if HourofDay==1 & TimeCategory==5

gen hour2=1 if HourofDay==2 & TimeCategory==1
replace hour2=2 if HourofDay==2 & TimeCategory==2
replace hour2=3 if HourofDay==2 & TimeCategory==3
replace hour2=4 if HourofDay==2 & TimeCategory==4
replace hour2=5 if HourofDay==2 & TimeCategory==5

gen hour3=1 if HourofDay==3 & TimeCategory==1
replace hour3=2 if HourofDay==3 & TimeCategory==2
replace hour3=3 if HourofDay==3 & TimeCategory==3
replace hour3=4 if HourofDay==3 & TimeCategory==4
replace hour3=5 if HourofDay==3 & TimeCategory==5

gen hour4=1 if HourofDay==4 & TimeCategory==1
replace hour4=2 if HourofDay==4 & TimeCategory==2
replace hour4=3 if HourofDay==4 & TimeCategory==3
replace hour4=4 if HourofDay==4 & TimeCategory==4
replace hour4=5 if HourofDay==4 & TimeCategory==5

gen hour5=1 if HourofDay==5 & TimeCategory==1
replace hour5=2 if HourofDay==5 & TimeCategory==2
replace hour5=3 if HourofDay==5 & TimeCategory==3
replace hour5=4 if HourofDay==5 & TimeCategory==4
replace hour5=5 if HourofDay==5 & TimeCategory==5

gen hour6=1 if HourofDay==6 & TimeCategory==1
replace hour6=2 if HourofDay==6 & TimeCategory==2
replace hour6=3 if HourofDay==6 & TimeCategory==3
replace hour6=4 if HourofDay==6 & TimeCategory==4
replace hour6=5 if HourofDay==6 & TimeCategory==5

gen hour7=1 if HourofDay==7 & TimeCategory==1
replace hour7=2 if HourofDay==7 & TimeCategory==2
replace hour7=3 if HourofDay==7 & TimeCategory==3
replace hour7=4 if HourofDay==7 & TimeCategory==4
replace hour7=5 if HourofDay==7 & TimeCategory==5

gen hour8=1 if HourofDay==8 & TimeCategory==1
replace hour8=2 if HourofDay==8 & TimeCategory==2
replace hour8=3 if HourofDay==8 & TimeCategory==3
replace hour8=4 if HourofDay==8 & TimeCategory==4
replace hour8=5 if HourofDay==8 & TimeCategory==5

gen hour9=1 if HourofDay==9 & TimeCategory==1
replace hour9=2 if HourofDay==9 & TimeCategory==2
replace hour9=3 if HourofDay==9 & TimeCategory==3
replace hour9=4 if HourofDay==9 & TimeCategory==4
replace hour9=5 if HourofDay==9 & TimeCategory==5

gen hour10=1 if HourofDay==10 & TimeCategory==1
replace hour10=2 if HourofDay==10 & TimeCategory==2
replace hour10=3 if HourofDay==10 & TimeCategory==3
replace hour10=4 if HourofDay==10 & TimeCategory==4
replace hour10=5 if HourofDay==10 & TimeCategory==5

gen hour11=1 if HourofDay==11 & TimeCategory==1
replace hour11=2 if HourofDay==11 & TimeCategory==2
replace hour11=3 if HourofDay==11 & TimeCategory==3
replace hour11=4 if HourofDay==11 & TimeCategory==4
replace hour11=5 if HourofDay==11 & TimeCategory==5

gen hour12=1 if HourofDay==12 & TimeCategory==1
replace hour12=2 if HourofDay==12 & TimeCategory==2
replace hour12=3 if HourofDay==12 & TimeCategory==3
replace hour12=4 if HourofDay==12 & TimeCategory==4
replace hour12=5 if HourofDay==12 & TimeCategory==5

gen hour13=1 if HourofDay==13 & TimeCategory==1
replace hour13=2 if HourofDay==13 & TimeCategory==2
replace hour13=3 if HourofDay==13 & TimeCategory==3
replace hour13=4 if HourofDay==13 & TimeCategory==4
replace hour13=5 if HourofDay==13 & TimeCategory==5

gen hour14=1 if HourofDay==14 & TimeCategory==1
replace hour14=2 if HourofDay==14 & TimeCategory==2
replace hour14=3 if HourofDay==14 & TimeCategory==3
replace hour14=4 if HourofDay==14 & TimeCategory==4
replace hour14=5 if HourofDay==14 & TimeCategory==5

gen hour15=1 if HourofDay==15 & TimeCategory==1
replace hour15=2 if HourofDay==15 & TimeCategory==2
replace hour15=3 if HourofDay==15 & TimeCategory==3
replace hour15=4 if HourofDay==15 & TimeCategory==4
replace hour15=5 if HourofDay==15 & TimeCategory==5

gen hour16=1 if HourofDay==16 & TimeCategory==1
replace hour16=2 if HourofDay==16 & TimeCategory==2
replace hour16=3 if HourofDay==16 & TimeCategory==3
replace hour16=4 if HourofDay==16 & TimeCategory==4
replace hour16=5 if HourofDay==16 & TimeCategory==5

gen hour17=1 if HourofDay==17 & TimeCategory==1
replace hour17=2 if HourofDay==17 & TimeCategory==2
replace hour17=3 if HourofDay==17 & TimeCategory==3
replace hour17=4 if HourofDay==17 & TimeCategory==4
replace hour17=5 if HourofDay==17 & TimeCategory==5
replace hour17=hour16 if hour17==.

gen hour18=1 if HourofDay==18 & TimeCategory==1
replace hour18=2 if HourofDay==18 & TimeCategory==2
replace hour18=3 if HourofDay==18 & TimeCategory==3
replace hour18=4 if HourofDay==18 & TimeCategory==4
replace hour18=5 if HourofDay==18 & TimeCategory==5


gen hour19=1 if HourofDay==19 & TimeCategory==1
replace hour19=2 if HourofDay==19 & TimeCategory==2
replace hour19=3 if HourofDay==19 & TimeCategory==3
replace hour19=4 if HourofDay==19 & TimeCategory==4
replace hour19=5 if HourofDay==19 & TimeCategory==5

gen hour20=1 if HourofDay==20 & TimeCategory==1
replace hour20=2 if HourofDay==20 & TimeCategory==2
replace hour20=3 if HourofDay==20 & TimeCategory==3
replace hour20=4 if HourofDay==20 & TimeCategory==4
replace hour20=5 if HourofDay==20 & TimeCategory==5

gen hour21=1 if HourofDay==21 & TimeCategory==1
replace hour21=2 if HourofDay==21 & TimeCategory==2
replace hour21=3 if HourofDay==21 & TimeCategory==3
replace hour21=4 if HourofDay==21 & TimeCategory==4
replace hour21=5 if HourofDay==21 & TimeCategory==5

gen hour22=1 if HourofDay==22 & TimeCategory==1
replace hour22=2 if HourofDay==22 & TimeCategory==2
replace hour22=3 if HourofDay==22 & TimeCategory==3
replace hour22=4 if HourofDay==22 & TimeCategory==4
replace hour22=5 if HourofDay==22 & TimeCategory==5

gen hour23=1 if HourofDay==23 & TimeCategory==1
replace hour23=2 if HourofDay==23 & TimeCategory==2
replace hour23=3 if HourofDay==23 & TimeCategory==3
replace hour23=4 if HourofDay==23 & TimeCategory==4
replace hour23=5 if HourofDay==23 & TimeCategory==5

gen hour24=1 if HourofDay==24 & TimeCategory==1
replace hour24=2 if HourofDay==24 & TimeCategory==2
replace hour24=3 if HourofDay==24 & TimeCategory==3
replace hour24=4 if HourofDay==24 & TimeCategory==4
replace hour24=5 if HourofDay==24 & TimeCategory==5

*generate hourly binary wellbeing variable
gen Enjoy=enj

gen jhour1=1 if HourofDay==1 & Enjoy>=6
replace jhour1=0 if HourofDay==1 & Enjoy<=5

gen jhour2=1 if HourofDay==2 & Enjoy>=6
replace jhour2=0 if HourofDay==2 & Enjoy<=5

gen jhour3=1 if HourofDay==3 & Enjoy>=6
replace jhour3=0 if HourofDay==3 & Enjoy<=5

gen jhour4=1 if HourofDay==4 & Enjoy>=6
replace jhour4=0 if HourofDay==4 & Enjoy<=5

gen jhour5=1 if HourofDay==5 & Enjoy>=6
replace jhour5=0 if HourofDay==5 & Enjoy<=5

gen jhour6=1 if HourofDay==6 & Enjoy>=6
replace jhour6=0 if HourofDay==6 & Enjoy<=5

gen jhour7=1 if HourofDay==7 & Enjoy>=6
replace jhour7=0 if HourofDay==7 & Enjoy<=5

gen jhour8=1 if HourofDay==8 & Enjoy>=6
replace jhour8=0 if HourofDay==8 & Enjoy<=5

gen jhour9=1 if HourofDay==9 & Enjoy>=6
replace jhour9=0 if HourofDay==9 & Enjoy<=5

gen jhour10=1 if HourofDay==10 & Enjoy>=6
replace jhour10=0 if HourofDay==10 & Enjoy<=5

gen jhour11=1 if HourofDay==11 & Enjoy>=6
replace jhour11=0 if HourofDay==11 & Enjoy<=5

gen jhour12=1 if HourofDay==12 & Enjoy>=6
replace jhour12=0 if HourofDay==12 & Enjoy<=5

gen jhour13=1 if HourofDay==13 & Enjoy>=6
replace jhour13=0 if HourofDay==13 & Enjoy<=5

gen jhour14=1 if HourofDay==14 & Enjoy>=6
replace jhour14=0 if HourofDay==14 & Enjoy<=5

gen jhour15=1 if HourofDay==15 & Enjoy>=6
replace jhour15=0 if HourofDay==15 & Enjoy<=5

gen jhour16=1 if HourofDay==16 & Enjoy>=6
replace jhour16=0 if HourofDay==16 & Enjoy<=5

gen jhour17=1 if HourofDay==17 & Enjoy>=6
replace jhour17=0 if HourofDay==17 & Enjoy<=5

gen jhour18=1 if HourofDay==18 & Enjoy>=6
replace jhour18=0 if HourofDay==18 & Enjoy<=5

gen jhour19=1 if HourofDay==19 & Enjoy>=6
replace jhour19=0 if HourofDay==19 & Enjoy<=5

gen jhour20=1 if HourofDay==20 & Enjoy>=6
replace jhour20=0 if HourofDay==20 & Enjoy<=5

gen jhour21=1 if HourofDay==21 & Enjoy>=6
replace jhour21=0 if HourofDay==21 & Enjoy<=5

gen jhour22=1 if HourofDay==22 & Enjoy>=6
replace jhour22=0 if HourofDay==22 & Enjoy<=5

gen jhour23=1 if HourofDay==23 & Enjoy>=6
replace jhour23=0 if HourofDay==23 & Enjoy<=5

gen jhour24=1 if HourofDay==24 & Enjoy>=6
replace jhour24=0 if HourofDay==24 & Enjoy<=5

collapse (mean)PersonID PersonalDuration PaidWorkDuration NonPaidWorkDuration LeisureDuration TravelDuration mainid survey enj labinc2 dagegrp sex hied occgroup region marstat numchild dmonth WorkingStatus (lastnm)hour1 (lastnm)hour2 (lastnm)hour3 (lastnm)hour4 (lastnm)hour5 (lastnm)hour6 (lastnm)hour7 (lastnm)hour8 (lastnm)hour9 (lastnm)hour10 (lastnm)hour11 (lastnm)hour12 (lastnm)hour13 (lastnm)hour14 (lastnm)hour15 (lastnm)hour16 (lastnm)hour17 (lastnm)hour18 (lastnm)hour19 (lastnm)hour20 (lastnm)hour21 (lastnm)hour22 (lastnm)hour23 (lastnm)hour24 (lastnm)jhour1 (lastnm)jhour2 (lastnm)jhour3 (lastnm)jhour4 (lastnm)jhour5 (lastnm)jhour6 (lastnm)jhour7 (lastnm)jhour8 (lastnm)jhour9 (lastnm)jhour10 (lastnm)jhour11 (lastnm)jhour12 (lastnm)jhour13 (lastnm)jhour14 (lastnm)jhour15 (lastnm)jhour16 (lastnm)jhour17 (lastnm)jhour18 (lastnm)jhour19 (lastnm)jhour20 (lastnm)jhour21 (lastnm)jhour22 (lastnm)jhour23 (lastnm)jhour24, by(MergeID)

replace hour1=hour24 if hour1==.
replace hour2=hour1 if hour2==.
replace hour3=hour2 if hour3==.
replace hour4=hour3 if hour4==.
replace hour5=hour4 if hour5==.
replace hour6=hour5 if hour6==.
replace hour7=hour6 if hour7==.
replace hour8=hour7 if hour8==.
replace hour9=hour8 if hour9==.
replace hour10=hour9 if hour10==.
replace hour11=hour10 if hour11==.
replace hour12=hour11 if hour12==.
replace hour13=hour12 if hour13==.
replace hour14=hour13 if hour14==.
replace hour15=hour14 if hour15==.
replace hour16=hour15 if hour16==.
replace hour17=hour16 if hour17==.
replace hour18=hour17 if hour18==.
replace hour19=hour18 if hour19==.
replace hour20=hour19 if hour20==.
replace hour21=hour20 if hour21==.
replace hour22=hour21 if hour22==.
replace hour23=hour22 if hour23==.
replace hour24=hour23 if hour24==.
*filling in activities that continue for than one hour

replace hour1=hour24 if hour1==.
replace hour2=hour1 if hour2==.
replace hour3=hour2 if hour3==.
replace hour4=hour3 if hour4==.
replace hour5=hour4 if hour5==.
replace hour6=hour5 if hour6==.
replace hour7=hour6 if hour7==.
replace hour8=hour7 if hour8==.
replace hour9=hour8 if hour9==.
replace hour10=hour9 if hour10==.
replace hour11=hour10 if hour11==.
replace hour12=hour11 if hour12==.
replace hour13=hour12 if hour13==.
replace hour14=hour13 if hour14==.
replace hour15=hour14 if hour15==.
replace hour16=hour15 if hour16==.
replace hour17=hour16 if hour17==.
replace hour18=hour17 if hour18==.
replace hour19=hour18 if hour19==.
replace hour20=hour19 if hour20==.
replace hour21=hour20 if hour21==.
replace hour22=hour21 if hour22==.
replace hour23=hour22 if hour23==.
replace hour24=hour23 if hour24==.
*filling in activities that continue for than one hour

replace jhour1=jhour24 if jhour1==.
replace jhour2=jhour1 if jhour2==.
replace jhour3=jhour2 if jhour3==.
replace jhour4=jhour3 if jhour4==.
replace jhour5=jhour4 if jhour5==.
replace jhour6=jhour5 if jhour6==.
replace jhour7=jhour6 if jhour7==.
replace jhour8=jhour7 if jhour8==.
replace jhour9=jhour8 if jhour9==.
replace jhour10=jhour9 if jhour10==.
replace jhour11=jhour10 if jhour11==.
replace jhour12=jhour11 if jhour12==.
replace jhour13=jhour12 if jhour13==.
replace jhour14=jhour13 if jhour14==.
replace jhour15=jhour14 if jhour15==.
replace jhour16=jhour15 if jhour16==.
replace jhour17=jhour16 if jhour17==.
replace jhour18=jhour17 if jhour18==.
replace jhour19=jhour18 if jhour19==.
replace jhour20=jhour19 if jhour20==.
replace jhour21=jhour20 if jhour21==.
replace jhour22=jhour21 if jhour22==.
replace jhour23=jhour22 if jhour23==.
replace jhour24=jhour23 if jhour24==.
*filling in activities that continue for than one hour

replace jhour1=jhour24 if jhour1==.
replace jhour2=jhour1 if jhour2==.
replace jhour3=jhour2 if jhour3==.
replace jhour4=jhour3 if jhour4==.
replace jhour5=jhour4 if jhour5==.
replace jhour6=jhour5 if jhour6==.
replace jhour7=jhour6 if jhour7==.
replace jhour8=jhour7 if jhour8==.
replace jhour9=jhour8 if jhour9==.
replace jhour10=jhour9 if jhour10==.
replace jhour11=jhour10 if jhour11==.
replace jhour12=jhour11 if jhour12==.
replace jhour13=jhour12 if jhour13==.
replace jhour14=jhour13 if jhour14==.
replace jhour15=jhour14 if jhour15==.
replace jhour16=jhour15 if jhour16==.
replace jhour17=jhour16 if jhour17==.
replace jhour18=jhour17 if jhour18==.
replace jhour19=jhour18 if jhour19==.
replace jhour20=jhour19 if jhour20==.
replace jhour21=jhour20 if jhour21==.
replace jhour22=jhour21 if jhour22==.
replace jhour23=jhour22 if jhour23==.
replace jhour24=jhour23 if jhour24==.
*filling in activities that continue for than one hour

save "/Users/jerrychen/Desktop/UKTUS 4-wave Hourly Variables JECH.dta", replace




*Merge the two UKTUS datasets
clear all
use "/Users/jerrychen/Desktop/UKTUS 4-wave Treated JECH"

gen inc=1 if Income<500
replace inc=2 if Income>=500 & Income<1000
replace inc=3 if Income>=1000 & Income<2000
replace inc=4 if Income>=2000 & Income<3000
replace inc=5 if Income>=3000 & Income<4000
replace inc=6 if Income>=4000 & Income<5000
replace inc=7 if Income>=5000
drop Income
rename inc labinc2
*Merging Income

rename Enjoy enj
*Merging Enjoyment

gen AgeG=1 if DVAge>=18 & DVAge<=24
replace AgeG=2 if DVAge>=25 & DVAge<=34
replace AgeG=3 if DVAge>=35 & DVAge<=44
replace AgeG=4 if DVAge>=45 & DVAge<=54
replace AgeG=5 if DVAge>=55 & DVAge<=64
replace AgeG=6 if DVAge>=65
rename AgeG dagegrp
*Merging and categorising Age

rename DMSex sex
*Merging gender

gen Edu=1 if dhiqual==5
replace Edu=2 if dhiqual==4
replace Edu=3 if dhiqual==3
replace Edu=4 if dhiqual==2
replace Edu=5 if dhiqual==1

replace hied=Edu if hied==.
*Merging education

gen soc=1 if dsoc>=8
replace soc=2 if dsoc>=5 & dsoc<=7
replace soc=3 if dsoc==4
replace soc=4 if dsoc==3
replace soc=5 if dsoc==2
replace soc=6 if dsoc==1
drop dsoc
rename soc occgroup
*Merging occupation

gen Area=1 if dgorpaf==7
replace Area=2 if dgorpaf==3
replace Area=3 if dgorpaf==4
replace Area=4 if dgorpaf==6
replace Area=5 if dgorpaf==8
replace Area=6 if dgorpaf==10
replace Area=7 if dgorpaf==5
replace Area=8 if dgorpaf==2
replace Area=9 if dgorpaf==12
replace Area=10 if dgorpaf==11
replace Area=11 if dgorpaf==13
replace Area=12 if dgorpaf==1
drop dgorpaf
rename Area region
*Merging region

gen Marriage=1 if MarStat==1
replace Marriage=2 if MarStat>=2 & MarStat<=4
replace Marriage=3 if MarStat>=5 & MarStat<=10
drop MarStat
rename Marriage marstat
*Merging Marital Status

rename NumChild numchild
rename IMonth dmonth


append using "/Users/jerrychen/Desktop/UKTUS 4-wave Hourly Variables JECH.dta"
save "/Users/jerrychen/Desktop/Merged 1415-1620 JECH.dta", replace


*LATENT CLASS ANALYSIS MODULE

use "/Users/jerrychen/Desktop/Merged 1415-1620 JECH.dta"
keep if WorkingStatus==1

gsem (hour1 hour2 hour3 hour4 hour5 hour6 hour7 hour8 hour9 hour10 hour11 hour12 hour13 hour14 hour15 hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23 hour24 <- _cons), family(multinomial) link(logit) lclass(A 3)

predict postp*, classposteriorpr
gen pclass=1 if postp1>0.5
replace pclass=2 if postp2>0.5
replace pclass=3 if postp3>0.5
save "/Users/jerrychen/Desktop/Merged 1415-2020 Homeworker LCA JECH.dta", replace


use "/Users/jerrychen/Desktop/Merged 1415-1620.dta"
keep if WorkingStatus==2

gsem (hour1 hour2 hour3 hour4 hour5 hour6 hour7 hour8 hour9 hour10 hour11 hour12 hour13 hour14 hour15 hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23 hour24 <- _cons), family(multinomial) link(logit) lclass(A 4) 
matrix b=e(b)
matrix list b
gsem (hour1 hour2 hour3 hour4 hour5 hour6 hour7 hour8 hour9 hour10 hour11 hour12 hour13 hour14 hour15 hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23 hour24 <- _cons), family(multinomial) link(logit) lclass(A 4) from(b)

predict postp*, classposteriorpr
gen pclass=1 if postp1>0.5
replace pclass=2 if postp2>0.5
replace pclass=3 if postp3>0.5
replace pclass=4 if postp4>0.5
save "/Users/jerrychen/Desktop/Merged 1415-2020 Commuter LCA JECH.dta", replace


use "/Users/jerrychen/Desktop/Merged 1415-1620.dta"
keep if WorkingStatus==3

gsem (hour1 hour2 hour3 hour4 hour5 hour6 hour7 hour8 hour9 hour10 hour11 hour12 hour13 hour14 hour15 hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23 hour24 <- _cons), family(multinomial) link(logit) lclass(A 3) nonrtolerance

predict postp*, classposteriorpr
gen pclass=1 if postp1>0.5
replace pclass=2 if postp2>0.5
replace pclass=3 if postp3>0.5
save "/Users/jerrychen/Desktop/Merged 1415-2020 Hybrid LCA JECH.dta", replace

append using "/Users/jerrychen/Desktop/Merged 1415-2020 Homeworker LCA JECH.dta"
append using "/Users/jerrychen/Desktop/Merged 1415-2020 Commuter LCA JECH.dta"

egen lifestyle = group(WorkingStatus pclass)
*generating the 10 lifstyles

replace survey=0 if survey==.
gen Covid=1 if survey<=1
replace Covid=0 if survey>=2
*gnerating variables to seperate pre and during Covid
drop if Duration<15
drop if PersonalDuration>20
drop if PaidWorkDuration>20
drop if NonPaidWorkDuration>20
drop if LeisureDuration>20
drop if TravelDuration>20

save "/Users/jerrychen/Desktop/Merged 1415-2020 LCA Classes ALL JECH.dta", replace
*the data is now exported to excel format to be visualised using MATLAB, resulting in Figure 2 of the paper


*generating Figure 1 - Summary Statistics
clear all 
use "/Users/jerrychen/Desktop/Merged 1415-2020 LCA Classes ALL JECH.dta"
keep if Covid==0
summtab, by(lifestyle) contvars(PersonalDuration PaidWorkDuration NonPaidWorkDuration LeisureDuration TravelDuration enj) catvars(sex dagegrp marstat region labinc hied occgroup) mean word wordname(Pre_COVID_Lifestyle_Summary_Table)replace
*Pre-COVID summary statitics generated

clear all 
use "/Users/jerrychen/Desktop/Merged 1415-2020 LCA Classes ALL JECH.dta"
keep if Covid==1
summtab, by(lifestyle) contvars(PersonalDuration PaidWorkDuration NonPaidWorkDuration LeisureDuration TravelDuration enj) catvars(sex dagegrp marstat region labinc hied occgroup) mean word wordname(During_COVID_Lifestyle_Summary_Table)replace
*During COVID summary statitics generated


*Individual level data is merged with activity-episode level data for the Figure 3 - multinomial logit model

*Pre-COVID activity-level data
use "/Users/jerrychen/Desktop/UKTUS15 Hourly Variables JECH.dta"
*data from UKTUS 2015
drop if Enjoy<1
drop _merge
merge m:1 MergeID using "/Users/jerrychen/Desktop/Merged 1415-2020 LCA Classes ALL JECH.dta"
*merge to obtain Lifestyle variable at the episode level
keep if _merge==3
save "/Users/jerrychen/Desktop/UKTUS15 Covid Logit Model.dta", replace

use "/Users/jerrychen/Desktop/UKTUS 4-wave Hourly Variables JECH.dta"
*data from 4 wave survey to keep 2016 data
merge m:1 MergeID using "/Users/jerrychen/Desktop/JECH LCA Final.dta"
*merge to obtain Lifestyle variable at the episode level
keep if _merge==3
drop if enj<1
keep if Covid==0
*only keeping 2016 survey
save "/Users/jerrychen/Desktop/2016 Covid Logit Model.dta", replace

append using "/Users/jerrychen/Desktop/UKTUS15 Covid Logit Model.dta"
save "/Users/jerrychen/Desktop/PreCovid Logit Model JECH.dta", replace

*During COVID activity-level data
clear all
use "/Users/jerrychen/Desktop/UKTUS 4-wave Hourly Variables JECH.dta"
*data from 4 wave survey to during Covid 
merge m:1 MergeID using "/Users/jerrychen/Desktop/Merged 1415-2020 LCA Classes ALL JECH.dta"
*merge to obtain Lifestyle variable at the episode level
keep if _merge==3
drop if enj<1
keep if Covid==1
*only keeping 2016 survey
save "/Users/jerrychen/Desktop/During Covid Logit Model JECH.dta", replace

*logit model to generate Figure 3
*Pre-COVID
clear all
use "/Users/jerrychen/Desktop/PreCovid Logit Model JECH.dta"
replace Enjoy=enj if Enjoy==.
gen Wellbeing=1 if Enjoy>=6
replace Wellbeing=0 if Enjoy<=5
logit Wellbeing i.lifestyle i.TimeCategory i.sex i.dagegrp i.marstat i.region i.labinc i.hied i.occgroup
margins i.lifestyle#i.TimeCategory

*During COVID
clear all
use "/Users/jerrychen/Desktop/During Covid Logit Model JECH.dta"
replace Enjoy=enj if Enjoy==.
gen Wellbeing=1 if Enjoy>=6
replace Wellbeing=0 if Enjoy<=5
logit Wellbeing i.lifestyle i.TimeCategory i.sex i.dagegrp i.marstat i.region i.labinc i.hied i.occgroup
margins i.lifestyle#i.TimeCategory




