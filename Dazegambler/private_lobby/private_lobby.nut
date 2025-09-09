local default_config = {
	lobby = 2699
};
local mod_name = "private_lobby";
cfg <- ::plugin.LoadCFG(mod_name+".ini",mod_name,default_config);
::setting.version = cfg.data.lobby;