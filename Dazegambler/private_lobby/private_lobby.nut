local default_cfg = {
	lobby = 2699
};
local mod_name = "private_lobby";
cfg <- ::plugin.LoadCFG(mod_name+".ini",mod_name,default_cfg);
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
::setting.version = cfg.data.lobby;

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

local cfg_str = "Lobby";
local table = cfg.data;
local sqkey = "lobby";
::menu.mod_config.Add(
	ConfigPage("Private Lobby",null,
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
					::setting.version = val;
					item[1].x = ::graphics.width - item_x - (item[1].width * item[1].sx);
				}
			}, "");
		})
	)
);