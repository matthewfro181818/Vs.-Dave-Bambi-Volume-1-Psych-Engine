-- Converted from DB v1.0.6 HXC
class BackseatIntro extends SongModule
{
    var black:FlxSprite;
    var cardGroup:FlxTypedSpriteGroup;

    public function new()
    {
        super('backseatIntro', 1, 'backseat');
    }

    function onCreate(e:ScriptEvent)
    {
        game.skipCountdown = true;
    }
    
    function onCreateUI(e:ScriptEvent)
    {
        game.camHUD.alpha = 0;

        black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        black.scale.set(FlxG.width * 2, FlxG.height * 2);
        black.updateHitbox();
        black.screenCenter();
        black.camera = game.camOther;
        game.add(black);
        
        cardGroup = new FlxTypedSpriteGroup();
        cardGroup.camera = game.camOther;
        cardGroup.scrollFactor.set();
        game.add(cardGroup);

        cardGroup.alpha = 0;

        buildCard();
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 4:
                FlxTween.tween(cardGroup, {alpha: 1}, 0.5);
            case 32:
                FlxTween.tween(game.camHUD, {alpha: 1}, 0.5);
                
                FlxTween.tween(cardGroup, {alpha: 0}, 0.5);
                FlxTween.tween(black, {alpha: 0}, 0.5);
        }
    }
    
    function buildCard()
    {
        card = new FlxSprite();
        card.frames = Paths.getSparrowAtlas('endings/backseat', 'shared');
        card.animation.addByPrefix('idle', 'backseat', 24);
        card.animation.play('idle', true);
        card.screenCenter();
        card.y -= 100;
        cardGroup.add(card);

        title = new FlxText(0, 460, 0, LanguageManager.getTextString('backseat_start_title'));
        title.setFormat(Paths.font('comic_normal.ttf'), 55, FlxColor.WHITE, 'center');
        title.screenCenter(0x01);
        cardGroup.add(title);

        titleDescription = new FlxText(0, 550, 0, LanguageManager.getTextString('backseat_start_description'));
        titleDescription.setFormat(Paths.font('comic_normal.ttf'), 24, FlxColor.WHITE, 'center');
        titleDescription.screenCenter(0x01);
        cardGroup.add(titleDescription);
    }
}
