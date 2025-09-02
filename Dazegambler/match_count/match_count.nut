this.score <- [0,0,0];
local initialize = ::menu.title.anime.Initialize;
::menu.title.anime.Initialize <- function () {
    ::plugin.list.match_count.score = [0,0,0];
    initialize();
}

local _initialize = ::menu.network.anime.Initialize;
::menu.network.anime.Initialize <- function () {
    ::plugin.list.match_count.score = [0,0,0];
    _initialize();
}


::plugin.Patch("data/script/battle/battle_vs_player.nut",function () {
    local createwindata = this.CreateWinData;
    function CreateWinData() {
        ::plugin.list.match_count.score[this.winner]++;
        createwindata();
    }
});

::plugin.Patch("data/system/select/script/character_select_animation.nut",function () {
    local init = this.Initialize;
    function Initialize() {
        init();
        local v = {};
        v.text <- ::font.CreateSystemString("0/0");
        v.text.ConnectRenderSlot(::graphics.slot.ui,10000);
        v.Update <- function() {
            local score = ::plugin.list.match_count.score;
            this.text.Set(::format("%d/%d",score[1],score[2]));
            this.text.sx = this.text.sy = 1.0;
            this.text.x = ::graphics.width / 2 - ((this.text.width * this.text.sx) / 2);
            this.text.y = ::graphics.height / 2 - ((this.text.height * this.text.sy) / 2);
        };
        this.data.push(v);
    }
});