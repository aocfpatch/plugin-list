//rsv_k0 = A
//rsv_k1 = B
//rsv_k2 = C
//rsv_k3 = E
//rsv_y = Y axis
//rsv_x = raw X axis
::plugin.Patch("data/actor/koishi_base.nut",function() {
	cooldowns <- [0,0,0];
	autoCancelTimer <- 30;
	local update_input = Update_Input;
	function Update_Input() {
		// local _motion = 5 + (command.rsv_x * direction) + (command.rsv_y * 3);
		foreach(i,_ in cooldowns)if(cooldowns[i]>0)cooldowns[i]--;
		foreach(i,_ in autoFunc) {
			if (command["rsv_k"+i]) {
				if(!_) {
				}else {
					if (cooldowns[i] > 0)continue;
					if (Cancel_Check(autoCancelLevel[i],0,0)) {
						cooldowns[i] = autoCancelTimer;
						if (autoFunc[i].call(this,autoTable[i])) {
							CommonAutoAttackReset(i);
							autoAttackTimes[i]++;
							return true;
						}
					}
				}
			}
		}
		update_input();
	}

	local commonautoattackset = CommonAutoAttackSet;
	function CommonAutoAttackSet(t,i) {
		cooldowns[i] = autoCancelTimer + (autoCancelTimer * (autoAttackTimes[i])) * (i == 2).tointeger();
		commonautoattackset(t,i);
	}
});