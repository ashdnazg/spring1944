Run()
{
	while (1)
		{
		
			if (IsProne==1||fear>0)
			{
			sleep 1000;
			}
			
			if (bMoving==1 && IsProne==0 && fear<=0)
			{
			call-script WeaponReady();	
			turn pelvis to y-axis <0> speed <40>*RUN_SPEED;
			turn pelvis to x-axis <4> speed <40>*RUN_SPEED;
			turn torso to x-axis <4> speed <40>*RUN_SPEED;
			turn torso to y-axis <-20> speed <5>*RUN_SPEED;
			move pelvis to y-axis [0.0] speed <100>*RUN_SPEED;
			}
			
				if (bMoving==1 && IsProne==0 && fear<=0)
			{
			Turn rleg to x-axis <85> speed<30>*WALK_SPEED;	
			Turn lleg to x-axis <55> speed<40>*WALK_SPEED;
			Turn rthigh to x-axis <-60> speed<20>*WALK_SPEED;
			Turn lthigh to x-axis <20> speed<20>*WALK_SPEED;			
		wait-for-move pelvis along y-axis;
			move pelvis to y-axis [1.25] speed <100>*RUN_SPEED;
			}
			
				if (bMoving==1 && IsProne==0 && fear<=0)
			{
			Turn rleg to x-axis <45> speed<60>*WALK_SPEED;
		wait-for-turn lthigh around x-axis;
			turn torso to y-axis <20> speed <5>*RUN_SPEED;
			move pelvis to y-axis [0.0] speed <100>*RUN_SPEED;
			Turn lleg to x-axis <85> speed<30>*WALK_SPEED;
			Turn rleg to x-axis <55> speed<40>*WALK_SPEED;
			Turn lthigh to x-axis <-60> speed<20>*WALK_SPEED;
			}
			
				if (bMoving==1 && IsProne==0 && fear<=0)
			{
			Turn rthigh to x-axis <20> speed<20>*WALK_SPEED;
		wait-for-move pelvis along y-axis;
			move pelvis to y-axis [1.25] speed <100>*RUN_SPEED;
			Turn lleg to x-axis <45> speed<60>*WALK_SPEED;	
		wait-for-turn rthigh around x-axis;
			}
			
			if (bMoving==0 && IsProne==0 && fear<=0)
			{
			move pelvis to y-axis [0.0] speed <100>*RUN_SPEED;
			turn pelvis to x-axis <0> speed <10>*RUN_SPEED;
			turn torso to x-axis <0> speed <10>*RUN_SPEED;
			wait-for-turn rthigh around x-axis;
			turn rthigh to x-axis <0> speed <100>*RUN_SPEED;
			wait-for-turn lthigh around x-axis;
			turn lthigh to x-axis <0> speed <100>*RUN_SPEED;
			turn lleg to x-axis <0> speed <100>*RUN_SPEED;
			turn rleg to x-axis <0> speed <100>*RUN_SPEED;
			}
											
		}
	}