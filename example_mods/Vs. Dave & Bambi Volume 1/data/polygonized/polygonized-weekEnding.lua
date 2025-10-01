-- Converted from DB v1.0.6 HXC
class PolygonizedWeekEnding extends SongModule
{
	public function new()
	{
		super('polygonizedWeek', 2, 'polygonized');
	}

	override function onCreate(e:ScriptEvent)
	{
		if (!PlayStatePlaylist.isStoryMode)
			return;

		game.endCallback = function()
		{
			var score:Int = PlayStatePlaylist.campaignScore;
			
			var params:EndingStateParams = if (score >= 350000) {
				{week: 'dave', ending: 'good', song: 'goodEnding', anims: [{name: 'idle', prefix: 'good_dave', loop: true}]}
			} else if (score >= 200000 && score < 350000) {
				{week: 'dave', ending: 'bad', song: 'badEnding', anims: [{name: 'idle', prefix: 'bad_dave', loop: true}]}
			} else {
				{week: 'dave', ending: 'worst', song: 'badEnding', anims: [{name: 'idle', prefix: 'worst_dave', loop: true}]}
			}
			FlxG.switchState(() -> new EndingState(params));
		}
	}
	
	function onGameOver(e:ScriptEvent)
	{
		if (game.boyfriend.id == 'bf-3d')
		{
			var params = {week: 'dave', ending: 'rtx', song: 'badEnding'}
			FlxG.switchState(new EndingState(params));
			e.cancel();
		}
	}
}
