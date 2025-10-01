-- Converted from DB v1.0.6 HXC
import flixel.tweens.misc.ColorTween;

class MazeDaytimeEffect extends SongModule
{
    var tweenList:Array<FlxTween>;
    var bfTween:ColorTween;
    var tweenTime:Float;

    public function new()
    {
        super('mazeDaytime', 0, 'maze');
    }

    function onCreateUI()
    {
        tweenList = [];
        
        var sky:BGSprite = game.currentStage.getProp('bg');	
        
        var sunsetBG:BGSprite = new BGSprite('sunsetBG', -600, -200, Paths.image('backgrounds/shared/sky_sunset'), null, 0.6, 0.6);
        sunsetBG.alpha = 0;
        sunsetBG.zIndex = sky.zIndex + 1;
        game.currentStage.add(sunsetBG);
        
        var nightBG:BGSprite = new BGSprite('nightBG', -600, -200, Paths.image('backgrounds/shared/sky_night'), null, 0.6, 0.6);
        nightBG.alpha = 0;
        nightBG.zIndex = sunsetBG.zIndex + 2;
        game.currentStage.add(nightBG);
        
        tweenTime = Conductor.instance.measureStartTime(25);
        for (bgSprite in MapTools.values(game.currentStage.namedProps))
        {		
            var tween:FlxTween = null;
            switch (bgSprite.spriteName) {
                case 'bg':
                    tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000);
                case 'sunsetBG':
                    tween = FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000));
                case 'nightBG':
                    tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000));
                default:
                    tween = FlxTween.color(bgSprite, tweenTime / 1000, FlxColor.WHITE, Stage.sunsetColor).then(
                    FlxTween.color(bgSprite, tweenTime / 1000, Stage.sunsetColor, Stage.nightColor));
            }
            tweenList.push(tween);
        }
        var gfTween = FlxTween.color(game.gf, tweenTime / 1000, FlxColor.WHITE, Stage.sunsetColor).then(FlxTween.color(game.gf, tweenTime / 1000, Stage.sunsetColor, Stage.nightColor));
        var bambiTween = FlxTween.color(game.dad, tweenTime / 1000, FlxColor.WHITE, Stage.sunsetColor).then(FlxTween.color(game.dad, tweenTime / 1000, Stage.sunsetColor, Stage.nightColor));
        bfTween = FlxTween.color(game.boyfriend, tweenTime / 1000, FlxColor.WHITE, Stage.sunsetColor, {
            onComplete: function(tween:FlxTween) {
                bfTween = FlxTween.color(game.boyfriend, tweenTime / 1000, Stage.sunsetColor, Stage.nightColor);
            }
        });
        tweenList.push(gfTween);
        tweenList.push(bambiTween);
        tweenList.push(bfTween);
        
        for (tween in tweenList) {
            tween.active = false;
        }
    }

    function onSongStart(e:ScriptEvent)
    {
        for (tween in tweenList)
        {
            tween.active = true;
            tween.percent = 0;
        }
    }

    function onUpdate(e:UpdateScriptEvent)
    {
        if (tweenList != null && tweenList.length != 0)
        {
            for (tween in tweenList) {
                if (tween.active && !tween.finished)
                    tween.percent = SoundController.music.time / tweenTime;
            }
        }
    }
}