local default_cfg = {
	input_delay = 4
}

local mod_name = "practice_delay";
cfg <- ::plugin.LoadCFG(mod_name + ".ini", mod_name, default_cfg);
function CheckIntegrity() {
	foreach(k, v in cfg.data) {
		if (typeof v == "table"){
			foreach(_k,_v in v) {
				if (!(_k in cfg.data[k])) cfg.Set(_v, _k, k);
			}
		}else {
			if (!(k in cfg.data)) cfg.Set(v, k);
		}
	}
}
CheckIntegrity();

local function ConfigPage(section,_table,...) {
	return function () {
		this.anime.data.push([]);
		this.proc.push([]);
		foreach (elem in vargv) {
			this.anime.data.top().push(elem[0]);
			this.proc.top().push(elem[1]);
		}
		local title = ::UI.Title(section);
		this.anime.data.top().push(title[0]);
		this.proc.top().push(title[1]);
	};
}

local cfg_str = "Input Delay";
local table = cfg.data;
local sqkey = "input_delay";
::menu.mod_config.Add(
	ConfigPage("Practice Delay",null,
		::UI.ValueField(cfg_str, [table,sqkey], function (item) {
			local item_x = this.anime.item_x;
			::Dialog(2, cfg_str, function (ret) {
				if (ret) {
					try{ret["to"+typeof table[sqkey]]();}
					catch (e){return;}
					local str = ret+"";
					local val = ret["to" + typeof table[sqkey]]();
					item[1].Set(val);
					::plugin.cfg[mod_name].Set(val,sqkey);
					item[1].x = ::graphics.width - item_x - (item[1].width * item[1].sx);
				}
			}, "");
		})
	)
);

::plugin.Patch("data/script/battle/battle_team.nut", function () {
	PlayerTeamData = class extends PlayerTeamData {
		input_buffer = null;
		constructor(){
			input_buffer = [];
			if (!SetDamage)SetDamage = SetDamageBase;
			if (!SetDamage_FullRegain)SetDamage_FullRegain = SetDamage_FullRegain_Base;
			if (!AddSP)AddSP = AddSP_Base;
		}
		function Update() {
			input.Update();
			if (!::network.IsActive() &&
				(!input.b10 && (!input.b0||!input.b1||!input.b2||!input.b3)) &&
				::plugin.cfg[mod_name].data.input_delay.tointeger() > 0) {
				local i = {};
				foreach(k, _ in input.__getTable) i[k] <- input[k];
				input_buffer.insert(0,i);
				local len = input_buffer.len();
				local diff = ::plugin.cfg[mod_name].data.input_delay.tointeger() - len;
				if (diff) {
					if (diff > 0) {
						local top = clone input_buffer.top();
						while(diff-- > 0)input_buffer.append(top);
					}else {
						while (diff++ < 0) input_buffer.pop();
					}
				}
				foreach(k, v in input_buffer.pop()) input[k] = v;
			}
			combo.Update();
		}
	}
});
// ::manbow.Actor2D.InputCommand <- class extends ::manbow.Actor2D.InputCommand {
// 	input_buffer = [];
// 	function Update(direction,keep) {
// 		com.Update(direction);
// 		local i = {
// 			com = {}
// 			device = {}
// 		};
// 		for (local z = 0; z < 6; ++z){
// 			local key = "b" + z;
// 			i.device[key] <- device[key];
// 			i.com[key] <- com[key];
// 		}
// 		i.device.b3r <- device.b3r;
// 		i.device.y <- device.y;
// 		i.device.x <- device.x;
// 		input_buffer.insert(0,i);
// 		local len = input_buffer.len();
// 		local diff = ::plugin.cfg[mod_name].data.input_delay - len;
// 		if (diff) {
// 			if (diff > 0) {
// 				local top = clone input_buffer.top();
// 				while(diff-- > 0)input_buffer.append(top);
// 			}else {
// 				while (diff++ < 0) input_buffer.pop();
// 			}
// 		}
// 		local input = input_buffer.pop();
// 		::battle.team[0].input.x = input.device.x;
// 		::battle.team[0].input.y = input.device.y;
// 		local inputSet_ = false;

// 		if (input.device.b4 == 0 || input.device.y <= 0 && ban_slide == 1 || input.device.y >= 0 && ban_slide == -1)
// 		{
// 			ban_slide = 0;
// 		}

// 		if (ban_b == 0)
// 		{
// 			if (input.com.b0 > 0 && input.com.b1 > 0)
// 			{
// 				rsv_k01 = 5;
// 				inputSet_ = true;
// 			}

// 			if (input.com.b1 > 0 && input.com.b2 > 0)
// 			{
// 				rsv_k12 = 5;
// 				inputSet_ = true;
// 			}

// 			if (input.com.b2 > 0 && input.com.b3 > 0)
// 			{
// 				rsv_k23 = 5;
// 				inputSet_ = true;
// 			}

// 			if (input.device.b0 == 2 || input.device.b0 == 0 && input.com.b0 > 0)
// 			{
// 				rsv_k0 = 5;
// 				inputSet_ = true;
// 			}

// 			if (input.device.b1 == 2 || input.device.b1 == 0 && input.com.b1 > 0)
// 			{
// 				rsv_k1 = 5;
// 				inputSet_ = true;
// 			}

// 			if (input.device.b2 == 2 || input.device.b2 == 0 && input.com.b2 > 0)
// 			{
// 				rsv_k2 = 5;
// 				inputSet_ = true;
// 			}

// 			if (input.device.b3r > 0)
// 			{
// 				rsv_k3_r = 10;
// 			}

// 			if (input.device.b3 == 2 || input.device.b3 == 0 && input.com.b3 > 0)
// 			{
// 				rsv_k3 = 7;
// 				inputSet_ = true;
// 			}
// 		}
// 		else
// 		{
// 			ban_b--;

// 			if (input.device.b0 == 0 && input.device.b1 == 0 && input.device.b2 == 0 && input.device.b3 == 0 && input.device.b4 == 0)
// 			{
// 				ban_b = 0;
// 			}
// 		}

// 		if (inputSet_)
// 		{
// 			reserve_count = 5;
// 			rsv_x = input.device.x;
// 			rsv_y = input.device.y;
// 		}
// 		else if (reserve_count == 1)
// 		{
// 			ResetReserve();
// 		}

// 		if (keep)
// 		{
// 			if (rsv_k0 > 0)
// 			{
// 				rsv_k0--;
// 			}

// 			if (rsv_k1 > 0)
// 			{
// 				rsv_k1--;
// 			}

// 			if (rsv_k2 > 0)
// 			{
// 				rsv_k2--;
// 			}

// 			if (rsv_k3 > 0)
// 			{
// 				rsv_k3--;
// 			}

// 			if (rsv_k3_r > 0)
// 			{
// 				rsv_k3_r--;
// 			}

// 			if (rsv_k4 > 0)
// 			{
// 				rsv_k4--;
// 			}

// 			if (rsv_k5 > 0)
// 			{
// 				rsv_k5--;
// 			}

// 			if (rsv_k01 > 0)
// 			{
// 				rsv_k01--;
// 			}

// 			if (rsv_k12 > 0)
// 			{
// 				rsv_k12--;
// 			}

// 			if (rsv_k23 > 0)
// 			{
// 				rsv_k23--;
// 			}
// 		}
// 	}
// }


