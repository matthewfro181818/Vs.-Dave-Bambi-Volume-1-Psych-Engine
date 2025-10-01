-- Converted from DB v1.0.6 HXC
import play.character.CharacterType;

class PolygonizedEndingCutscene extends SongModule
{
    var normalStage:Stage;
    var nightStage:Stage;
    
    public function new()
    {
        super('polygonizedEnding', 1, 'polygonized');
    }

    override function onCreate(e:ScriptEvent):Void
    {
        Preloader.cacheCharacter('dave-polygonized-end', CharacterType.OPPONENT);
    }

    override function onCreatePost():Void
    {
        normalStage = game.currentStage;

        nightStage = game.loadStage('house-night');
        nightStage.forEachProp((prop:FlxSprite) ->
        {
            prop.alpha = 0.001;
        });
        game.add(nightStage);
    }
    
    function onBeatHit()
    {
        switch (e.beat)
        {
            case 608:
                game.defaultCamZoom = 0.8;

                if (Preferences.flashingLights)
                    FlxG.camera.flash(FlxColor.WHITE, 0.25);

                normalStage.forEachProp((prop:FlxSprite) ->
                {
                    FlxTween.tween(prop, {alpha: 0}, 1);
                });
                nightStage.forEachProp((prop:FlxSprite) ->
                {
                    FlxTween.tween(prop, {alpha: 1}, 1);
                });
                normalStage.moveCharactersToStage(nightStage);
                game.currentStage = nightStage;

                game.boyfriend.canSing = false;
                game.boyfriend.canDance = false;
                game.boyfriend.playAnim('hey', true);
                game.boyfriend.alpha = 1;
                
                game.gf.canSing = false;
                game.gf.canDance = false;
                game.gf.playAnim('cheer', true);
                game.gf.alpha = 1;

                game.switchDad('dave-polygonized-end', game.dad.getPosition());
                game.dad.alpha = 1;

                game.dadStrums.noteStyle = game.dad.skins.get('noteSkin');
                game.dadStrums.regenerate();
                game.timer.switchType(game.dad.skins.get('noteSkin'));

                game.camGame.overrideFollowPoint = new FlxPoint(game.gf.cameraFocusPoint.x, game.gf.cameraFocusPoint.y);
        }
    }
}