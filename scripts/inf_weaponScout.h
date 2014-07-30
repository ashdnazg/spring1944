/*
--Infantry Weapon Pistol/Scout--
Here is: aiming logic and animation and firing FX/animation

This script assumes that any infantry with binocs in weapon slot #1, and a pistol in weapon slot #2

Functions:
AimFromWeapon1(piecenum)
QueryWeapon1(piecenum)
AimWeapon1(heading, pitch)
FireWeapon1()

AimFromWeapon2(piecenum)
QueryWeapon2(piecenum)
AimWeapon2(heading, pitch)
Shot2()---NEEDS FIXING SO THEIR ARMS MOVE
FireWeapon2()

*/

#define VISIBLE_PERIOD	5000

AimFromWeapon1(piecenum)
{
	piecenum = flare;
}

QueryWeapon1(piecenum)
{
	piecenum = flare;
}

AimWeapon1(heading, pitch)
{
	signal SIG_AIM1;
	set-signal-mask SIG_AIM1;
	signal SIG_IDLE;
	bAiming=3;
	if (iState >= 6) return 0; //if the unit is suppressed/pinned, we don't even bother aiming or calling the control loop
	if (iState < 6)
	{
		show binoculars;
		turn pelvis to x-axis <0> speed <200>;
		turn pelvis to y-axis heading speed <300>;
		turn pelvis to z-axis <0> speed <300>;
				
		turn torso to x-axis <0> speed <200>;
		turn torso to y-axis <0>-pitch speed <200>;	
		turn torso to z-axis <0> speed <200>;	
					
		turn head to x-axis <0> speed <200>;
		turn head to y-axis <0> speed <200>;
		turn head to z-axis <0> speed <200>;	
		
		turn rthigh to x-axis <0> speed <199>;
		turn rthigh to y-axis <0> speed <199>;
		turn rthigh to z-axis <0> speed <199>;	
				
		turn rleg to x-axis <0> speed <199>;
		turn rleg to y-axis <0> speed <199>;
		turn rleg to z-axis <0> speed <199>;
			
		turn lthigh to x-axis <0> speed <199>;
		turn lthigh to y-axis <0> speed <199>;
		turn lthigh to z-axis <0> speed <199>;
				
		turn lleg to x-axis <0> speed <199>;
		turn lleg to y-axis <0> speed <199>;
		turn lleg to z-axis <0> speed <199>;
		
		turn torso to y-axis <0> speed <600>;
		
		wait-for-turn head around x-axis;
		wait-for-turn head around y-axis;
		wait-for-turn head around z-axis;
				
		wait-for-turn pelvis around x-axis;	
		wait-for-turn pelvis around y-axis;	
		wait-for-turn pelvis around z-axis;	
				
		wait-for-turn lthigh around x-axis;
		wait-for-turn lthigh around y-axis;
		wait-for-turn lthigh around z-axis;
				
		wait-for-turn lleg around x-axis;
		wait-for-turn lleg around y-axis;
		wait-for-turn lleg around z-axis;
				
		wait-for-turn rthigh around x-axis;
		wait-for-turn rthigh around y-axis;
		wait-for-turn rthigh around z-axis;	
				
		wait-for-turn rleg around x-axis;
		wait-for-turn rleg around y-axis;
		wait-for-turn rleg around z-axis;
				
		wait-for-turn torso around x-axis;
		wait-for-turn torso around y-axis;
		wait-for-turn torso around z-axis;
				
			
		wait-for-turn ruparm around x-axis;
		wait-for-turn ruparm around y-axis;
		wait-for-turn ruparm around z-axis;	
				
		wait-for-turn rloarm around x-axis;
		wait-for-turn rloarm around y-axis;
		wait-for-turn rloarm around z-axis;	
				

		turn luparm to x-axis <-70> speed <500>;
		turn luparm to y-axis <20> speed <500>;
		turn luparm to z-axis <0> speed <500>;
		turn lloarm to x-axis <-110> speed <500>;
		turn lloarm to y-axis <-35> speed <500>;
		turn lloarm to z-axis <0> speed <500>;
		turn binoculars to x-axis <-10> speed <500>;
		turn binoculars to y-axis <10> speed <500>;
		turn binoculars to z-axis <-30> speed <500>;
		
		wait-for-turn binoculars around x-axis;
		wait-for-turn binoculars around y-axis;
		wait-for-turn binoculars around z-axis;
		
		wait-for-turn lloarm around x-axis;
		wait-for-turn lloarm around y-axis;
		wait-for-turn lloarm around z-axis;	
				
		wait-for-turn luparm around x-axis;
		wait-for-turn luparm around y-axis;	
		wait-for-turn luparm around z-axis;	
		return (1);	
	}	
	return (0);
}
FireWeapon1()
{
	SET ACTIVATION to 1;
	sleep VISIBLE_PERIOD;
	SET ACTIVATION to 0;
}

AimFromWeapon2(piecenum)
{
	piecenum = flare;
}

QueryWeapon2(piecenum)
{
	piecenum = flare;
}

AimWeapon2(heading, pitch)
{
	signal SIG_AIM1;
	signal SIG_AIM2;
	set-signal-mask SIG_AIM2;
	signal SIG_IDLE;
	bAiming=3;
	if (iState == 9) return 0; //if the unit is pinned, we don't even bother aiming or calling the control loop
	if (iState >= 6)
	{
		iState=7; //prone aiming
		turn torso to y-axis <0> speed <600>;
		turn ruparm to x-axis <-85> - pitch speed <480>;
		turn luparm to x-axis <-140> - pitch speed <400>;
		turn pelvis to y-axis heading speed <120>;
		wait-for-turn luparm around x-axis;
		wait-for-turn ruparm around x-axis;
		wait-for-turn torso around y-axis;
		wait-for-turn pelvis around y-axis;
		start-script RestoreAfterDelay();
		return (1);
	}
	if (iState<6)
	{	
		iState=2; //standing aiming
		
		turn pelvis to x-axis <0> speed <200>;
		turn pelvis to y-axis heading speed <300>;
		turn pelvis to z-axis <0> speed <300>;
				
		turn torso to x-axis <0> speed <200>;
		turn torso to y-axis <0>-pitch speed <200>;	
		turn torso to z-axis <0> speed <200>;	
					
		turn head to x-axis <0> speed <200>;
		turn head to y-axis <0> speed <200>;
		turn head to z-axis <0> speed <200>;	
		
		turn rthigh to x-axis <0> speed <199>;
		turn rthigh to y-axis <0> speed <199>;
		turn rthigh to z-axis <0> speed <199>;	
				
		turn rleg to x-axis <0> speed <199>;
		turn rleg to y-axis <0> speed <199>;
		turn rleg to z-axis <0> speed <199>;
			
		turn lthigh to x-axis <0> speed <199>;
		turn lthigh to y-axis <0> speed <199>;
		turn lthigh to z-axis <0> speed <199>;
				
		turn lleg to x-axis <0> speed <199>;
		turn lleg to y-axis <0> speed <199>;
		turn lleg to z-axis <0> speed <199>;	
					
		turn ruparm to x-axis <0> speed <300>;
		turn ruparm to y-axis <50> speed <300>;
		turn ruparm to z-axis <70> speed <300>;	
						
		turn rloarm to x-axis <-50> speed <300>;
		turn rloarm to y-axis <0> speed <300>;
		turn rloarm to z-axis <0> speed <300>;	
						
		turn gun to x-axis <0> speed <300>;
		turn gun to y-axis <0> speed <300>;
		turn gun to z-axis <10> speed <300>;	
						
		turn luparm to x-axis <-50> speed <300>;
		turn luparm to y-axis <40> speed <300>;
		turn luparm to z-axis <0> speed <300>;	
						
		turn lloarm to x-axis <-20> speed <300>;
		turn lloarm to y-axis <0> speed <300>;
		turn lloarm to z-axis <50> speed <300>;
		
		wait-for-turn head around x-axis;
		wait-for-turn head around y-axis;
		wait-for-turn head around z-axis;
				
		wait-for-turn pelvis around x-axis;	
		wait-for-turn pelvis around y-axis;	
		wait-for-turn pelvis around z-axis;	
				
		wait-for-turn lthigh around x-axis;
		wait-for-turn lthigh around y-axis;
		wait-for-turn lthigh around z-axis;
				
		wait-for-turn lleg around x-axis;
		wait-for-turn lleg around y-axis;
		wait-for-turn lleg around z-axis;
				
		wait-for-turn rthigh around x-axis;
		wait-for-turn rthigh around y-axis;
		wait-for-turn rthigh around z-axis;	
				
		wait-for-turn rleg around x-axis;
		wait-for-turn rleg around y-axis;
		wait-for-turn rleg around z-axis;
				
		wait-for-turn torso around x-axis;
		wait-for-turn torso around y-axis;
		wait-for-turn torso around z-axis;
				
		wait-for-turn lloarm around x-axis;
		wait-for-turn lloarm around y-axis;
		wait-for-turn lloarm around z-axis;	
				
		wait-for-turn luparm around x-axis;
		wait-for-turn luparm around y-axis;	
		wait-for-turn luparm around z-axis;	
				
		wait-for-turn ruparm around x-axis;
		wait-for-turn ruparm around y-axis;
		wait-for-turn ruparm around z-axis;	
				
		wait-for-turn rloarm around x-axis;
		wait-for-turn rloarm around y-axis;
		wait-for-turn rloarm around z-axis;	
				
		wait-for-turn gun around x-axis;
		wait-for-turn gun around y-axis;
		wait-for-turn gun around z-axis;
		start-script RestoreAfterDelay();	
		return (1);	
	}	
	return (0);
}

#define SHOT_ANIM_STANDING\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to y-axis <30> now;\
		turn rloarm to x-axis <-75> now;\
		sleep (BurstRate/2);\
		turn ruparm to y-axis <50> now;\
		turn rloarm to x-axis <-50> now;\
		sleep (BurstRate/2);
		
#define SHOT_ANIM_KNEELING\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <-4> now;\
		turn luparm to x-axis <-85> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <0> now;\
		turn luparm to x-axis <-80> now;\
		sleep (BurstRate/2);
		
#define SHOT_ANIM_RUNNING\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <47.5> now;\
		turn rloarm to x-axis <-125> now;\
		turn luparm to x-axis <-62.5> now;\
		turn lloarm to x-axis <-20> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <50> now;\
		turn rloarm to x-axis <-120> now;\
		turn luparm to x-axis <-60> now;\
		turn lloarm to x-axis <-15> now;\
		sleep (BurstRate/2);
		
#define SHOT_ANIM_PRONE\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <-95> now;\
		turn luparm to x-axis <-150> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <-85> now;\
		turn luparm to x-axis <-140> now;\
		sleep (BurstRate/2);
		
FireWeapon2()
{
	if (iState!=7)
		{
		SHOT_ANIM_STANDING
		}	
		
	if (iState==7)
		{
		SHOT_ANIM_PRONE
		}
	SET ACTIVATION to 1;
	sleep VISIBLE_PERIOD;
	SET ACTIVATION to 0;
	return (0);
}