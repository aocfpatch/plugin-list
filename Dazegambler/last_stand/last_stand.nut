::plugin.Patch("data/script/battle/battle_team.nut", function () {
	local teamdata = this.PlayerTeamData;
	teamdata.second_wind <- true;
	local update = teamdata.Update;
	teamdata.Update <- function () {
		update();
		if (!this.second_wind) {
			this.SetDamage(2,true);
		}
	}
	local resetround = teamdata.ResetRound;
	teamdata.ResetRound <- function () {
		resetround();
		this.second_wind = true;
	}
	teamdata.CheckKO <- function () {
		if (this.life <= 0 && this.current.enableKO) {
			if (this.second_wind) {
				this.current.Team_Bench_Suicide(null);
				this.slave_ban = this.op = 100000000000000000000;
				this.life = this.regain_life = this.damage_life = this.life_max;
				this.second_wind = false;
				return false;
			}else {
				return true;
			}
		}
	}
});
::plugin.Patch("data/actor/player_team_move.nut", function () {
	function Team_Bench_Suicide( t_ ) {
		this.LabelClear();
		this.ResetSpeed();
		this.Team_Change_Common();
		this.DrawActorPriority(189);
		this.SetMotion(218, 0);
		this.team.current.Team_Change_Suicide(this.direction);
		this.SetSpeed_XY(-1.50000000 * this.direction, -11.00000000);
		this.count = 0;
		this.subState = function ()
		{
			this.AddSpeed_XY(0.00000000, 0.34999999);

			if (this.va.y > -1.00000000)
			{
				this.subState = function ()
				{
					this.AddSpeed_XY(0.00000000, 0.05000000);
				};
			}
		};
		this.stateLabel = function ()
		{
			this.vf.x = this.vf.y = this.vfBaria.x = this.vfBaria.y = 0.00000000;
			this.subState();

			if (this.va.x > 0 && this.x > ::battle.corner_right || this.va.x < 0 && this.x < ::battle.corner_left)
			{
				this.SetSpeed_XY(0.00000000, null);
			}

			if (this.count == 25)
			{
				this.PlaySE(847);
				this.SetCommonShot(this.x, this.y, this.direction, this.Suicide_Exp, {});
				this.Team_Bench_In();
				return;
			}
		};
	}
});