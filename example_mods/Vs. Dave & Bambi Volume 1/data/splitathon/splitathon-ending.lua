-- Converted from DB v1.0.6 HXC
class SplitathonEnding extends SongModule
{
    var black:FlxSprite;
    var text:FlxText;

    public function new()
    {
        super('splitathonEnd', 0, 'splitathon');
    }

    override function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {
            game.startCallback = () -> {
                game.beginStartDialogue('splitathon');
            }
            game.endCallback = function() {
                game.endSongDialogue('splitathon-endDialogue', function() {
                    
                    toBeContinued();
                });
            }
        }
    }

    function toBeContinued():Void
    {
        FlxTween.tween(game.camHUD, {alpha: 0}, 0.5);

        black = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
        black.scale.set(FlxG.width, FlxG.height);
        black.updateHitbox();
        black.alpha = 0.001;
        black.camera = game.camOther;
        game.add(black);
        FlxTween.tween(black, {alpha: 1}, 0.5);

        text = new FlxText(0, 0, 0, LanguageManager.getTextString('ending_splitathon'));
        text.setFormat(Paths.font('comic.ttf'), 36, FlxColor.WHITE, 'center');
        text.screenCenter();
        text.alpha = 0;
        text.camera = game.camOther;
        game.add(text);
        FlxTween.tween(text, {alpha: 1}, 0.5);

        new FlxTimer().start(2, (t:FlxTimer) -> 
        {
            FlxTween.tween(text, {alpha: 0}, 1, {
                onComplete: (t:FlxTween) ->
                {
                    FlxG.save.data.splitathonBeat = true;
                    FlxG.save.flush();
                    
                    FlxG.sound.playMusic(Paths.music('freakyMenu'));
                    FlxG.switchState(new StoryMenuState());
                }
            });
        });
    }
}