-- Converted from DB v1.0.6 HXC
import flixel.util.FlxGradient;
import play.notes.Strumline;
import play.stage.ScriptedStage;
import play.song.SongPlayChart;
import play.character.CharacterType;

class BackseatEvents extends SongModule
{
    var stage:ScriptedStage;

    // INSANITY //
    var insanityConductor:Conductor = new Conductor();

    var outsideGroup:FlxTypedSpriteGroup;
    var floatingGroup:FlxTypedSpriteGroup;

    var floatingInfo:Array<Dynamic> = [];

    var daveChar:Character;
    var gfChar:Character;
    var bfChar:Boyfriend;
    var bfComboCount:Int = 0;

    var insanityDaveStrumline:Strumline;
    var insanityBfStrumline:Strumline;

    var noteOffsetTime:Float = 40000;

    var daveScared:FlxSprite;
    var gfScared:FlxSprite;
    var bfScared:FlxSprite;

    var whiteFlash:FlxSprite;

    // Here to help make prevent a lagspike from making duplicates.
    var floatingCharsInitalized:Bool = false;

    public function new()
    {
        super('backseatEvents', 0, 'backseat');
    }

    function onCreate(e:ScriptEvent):Void
    {
        Preloader.cacheImage(Paths.imagePath('backgrounds/tristanBackseat/3d_bf_backseat'));
        Preloader.cacheImage(Paths.imagePath('backgrounds/tristanBackseat/gf_3d_backseat'));
    }

    function onCreatePost(e:ScriptEvent)
    {
        game.camMoveOnNoteAllowed = false;
        stage = game.currentStage;

        var stageBg:BGSprite = stage.getProp('bg');

        outsideGroup = new FlxTypedSpriteGroup();
        outsideGroup.zIndex = stageBg.zIndex - 5;
        stage.add(outsideGroup);

        floatingGroup = new FlxTypedSpriteGroup();
        outsideGroup.add(floatingGroup);
        floatingGroup.visible = false;

        gfChar = Character.create(550, 290, 'gf', CharacterType.GF);
        gfChar.setScale(0.4, 0.4);
        gfChar.offsetScale = 0.4;
        gfChar.dance();
        outsideGroup.add(gfChar);
        gfChar.scrollFactor.set(0.8, 1);

        daveChar = Character.create(430, 350, 'dave-annoyed', CharacterType.OPPONENT);
        daveChar.setScale(0.4, 0.4);
        daveChar.offsetScale = 0.4;
        daveChar.dance();
        outsideGroup.add(daveChar);
        daveChar.scrollFactor.set(0.8, 1);
        
        bfChar = Character.create(750, 425, 'bf', CharacterType.OTHER);
        bfChar.setScale(0.4, 0.4);
        bfChar.offsetScale = 0.4;
        bfChar.dance();
        outsideGroup.add(bfChar);
        bfChar.scrollFactor.set(0.8, 1);

        bfChar.flipX = !bfChar.flipX;

        initalizeFloatingChars();
        generateInsanity();

        var roomBg:BGSprite = stage.getProp('bg');

        whiteFlash = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
        whiteFlash.scale.set(FlxG.width, FlxG.height);
        whiteFlash.updateHitbox();
        whiteFlash.alpha = 0;
        whiteFlash.zIndex = roomBg.zIndex - 1;
        stage.add(whiteFlash);
    }

    function onCreateUI(e:ScriptEvent)
    {
        if (game.timer != null) {
            game.timer.pieTimer.color = FlxColor.WHITE;
            FlxGradient.overlayGradientOnFlxSprite(game.timer.pieTimer, game.timer.pieTimer.width, game.timer.pieTimer.height, [game.dad.characterColor, game.boyfriend.characterColor], 1, 0, 1, 90);
        }
    }

    function onUpdate(e:UpdateScriptEvent)
    {
        insanityConductor.update(Conductor.instance.songPosition + noteOffsetTime);

        insanityDaveStrumline.update(e.elapsed);
        insanityBfStrumline.update(e.elapsed);

        for (char in floatingGroup.members)
        {
            var floatingIndex:Int = floatingGroup.members.indexOf(char);
            switch (floatingInfo[floatingIndex])
            {
                case 'left':
                    // Rough estimate.
                    if (char.x > FlxG.width - 200 - char.width / 2)
                    {
                        switchDirection(floatingIndex);
                    }
                case 'right':
                    if (char.x < 200 - char.width / 2)
                    {
                        switchDirection(floatingIndex);
                    }
                    
            }
        }
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 416:
                game.defaultCamZoom += 0.1;
            case 644:
                shakeBackground((Conductor.instance.stepCrochet * 28) / 1000);
            case 672:
                FlxG.camera.shake(0.01);

                game.camGame.removeTarget();
                game.defaultCamZoom -= 0.2;

                game.boyfriend.canDance = false;
                game.boyfriend.playAnim('scared', true);
                game.boyfriend.animation.onFinish.addOnce((anim:String) ->
                {
                    if (anim == 'scared')
                    {
                        game.boyfriend.playAnim('scared-idle', true);
                    }
                });

                game.dad.canDance = false;
                game.dad.playAnim('scared', true);

                flashSwitchBackground();
            case 688:
                game.defaultCamZoom += 0.1;
            case 704:
                game.camGame.setTarget();
                game.dad.canDance = true;
                game.defaultCamZoom += 0.1;
            case 768:
                game.boyfriend.canDance = true;
            case 944:
                game.defaultCamZoom = 1.2;
            case 960, 1024:
                game.defaultCamZoom = 1.1;
            case 992, 1056:
                game.defaultCamZoom -= 0.1;
            case 1088, 1152:
                game.camGame.removeTarget();
                game.defaultCamZoom = 0.8;
                
                FlxTween.tween(FlxG.camera.scroll, {x: FlxG.camera.scroll.x - 100}, 0.5, {ease: FlxEase.backOut});
            case 1120, 1128, 1184, 1192:
                game.defaultCamZoom += 0.15;
            case 1136, 1200:
                game.defaultCamZoom = 1.0;
            case 1216:
                game.defaultCamZoom = 0.7;

                game.dad.canDance = false;
                game.boyfriend.canDance = false;

                game.dad.playAnim('scared2', true);
                game.boyfriend.playAnim('scared2', true);
                
                FlxG.camera.shake(0.01);
                flashBg();
                changeFloatingCharsTo3D();
            case 1232:
                game.camGame.setTarget();
                game.defaultCamZoom = 0.8;
            case 1248:
                FlxG.camera.zoom = game.defaultCamZoom = 1.0;

                game.boyfriend.canDance = true;
                game.dad.canDance = true;
            case 1504:
                game.defaultCamZoom = 0.8;
            case 1520:
                game.defaultCamZoom -= 0.1;
        }
    }

    function generateInsanity()
    {
        var insanitySong:Song = SongRegistry.instance.fetchEntry('insanity');
        var chart:SongPlayChart = insanitySong.getChart();
        
        insanityConductor.mapTimeChanges(chart.timeChanges);
        insanityConductor.reset();
        insanityConductor.update(noteOffsetTime, false);

        gfChar.conductor = insanityConductor;
        daveChar.conductor = insanityConductor;
        bfChar.conductor = insanityConductor;

        // None of these parameters actually matter since they aren't shown in-game.
        // We only care about using these so the characters sing.
        insanityDaveStrumline = new Strumline({isPlayer: false, noteStyle: daveChar.skins.get('noteSkin'), scrollType: game.scrollType});
        insanityDaveStrumline.conductor = insanityConductor;
        insanityDaveStrumline.generateNotes(chart.notes);
        insanityDaveStrumline.onNoteSpawn.add((note:Note) -> 
        {
            // This MUST be done or else the actual characters in the song will sing weirdly.
            note.setCharacter(daveChar);
            if (note.sustainNote != null)
            {
                note.sustainNote.character = daveChar;
            }
        });
        insanityDaveStrumline.onNoteHit.add((note:Note) -> 
        {
            daveChar.sing(note.direction);
        });
        
        insanityBfStrumline = new Strumline({isPlayer: true, noteStyle: bfChar.skins.get('noteSkin'), scrollType: game.scrollType});
        insanityBfStrumline.conductor = insanityConductor;
        insanityBfStrumline.generateNotes(chart.notes);
        insanityBfStrumline.onNoteSpawn.add((note:Note) -> 
        {
            note.setCharacter(bfChar);
            if (note.sustainNote != null)
            {
                note.sustainNote.character = bfChar;
            }
        });

        // This makes it so BF strumline isn't a strumline you have to hit.
        // We want to do this after we generate notes though because the function relies on whether the strumline's player based, or not.
        insanityBfStrumline.isPlayer = false;
        insanityBfStrumline.onNoteHit.add((note:Note) -> 
        {
            var shouldMiss:Bool = FlxG.random.bool(15);
            
            bfChar.sing(note.direction, shouldMiss);
            if (shouldMiss && bfComboCount > 10)
            {
                bfComboCount = 0;
                gfChar.playAnim('sad', true);
            }
            else
            {
                bfComboCount += 1;
            }
        });
    }
    function shakeBackground(time:Float)
    {
        var daveBg:Array<BGSprite> = stage.scriptCall('getDaveStage');

        for (i in 0...daveBg.length)
        {
            if (i == 0)
                continue;

            var bg:BGSprite = daveBg[i];

            IntervalShake.shake(daveChar, time, 0.008, 0, 0.01, 0x11, FlxEase.linear);
            IntervalShake.shake(gfChar, time, 0.008, 0, 0.01, 0x11, FlxEase.linear);
            IntervalShake.shake(bfChar, 3, 0.008, 0, 0.01, 0x11, FlxEase.linear);

            IntervalShake.shake(bg, time, 0.005, 0, 0.01, 0x11, FlxEase.linear);
        }
    }
    function flashSwitchBackground()
    {
        flashBg();
        
        var daveBg:Array<BGSprite> = stage.scriptCall('getDaveStage');

        // Hide normal background.
        for (bg in daveBg)
        {
            bg.alpha = 0;
        }

        // Hide characters.
        daveChar.visible = false;
        bfChar.visible = false;
        gfChar.visible = false;

        floatingGroup.visible = true;

        var void:BGSprite = stage.getProp('void');
        void.alpha = 1;
    }

    function flashBg()
    {
        whiteFlash.alpha = 1;
        FlxTween.tween(whiteFlash, {alpha: 0}, 3, 
        {
            startDelay: 1.5,
        });
    }

    function initalizeFloatingChars()
    {
        if (floatingCharsInitalized)
            return;

        floatingGroup.clear();
        
        var directions:Array<String> = ['left', 'right'];
        var randomDirection:String = directions[FlxG.random.int(0, directions.length - 1)];

        gfScared = new FlxSprite(550, 350);
        gfScared.frames = Paths.getSparrowAtlas('backgrounds/tristanBackseat/GF_Scared');
        gfScared.animation.addByPrefix('idle', 'GF FEAR', 24);
        gfScared.animation.play('idle', true);
        gfScared.scrollFactor.set(0.8, 1);
        gfScared.scale.set(0.4, 0.4);
        gfScared.updateHitbox();
        floatingGroup.add(gfScared);
        setDirection(randomDirection, 0, gfScared);

        randomDirection = directions[FlxG.random.int(0, directions.length - 1)];

        daveScared = new FlxSprite(430, 350).loadGraphic(Paths.image('backgrounds/tristanBackseat/dave_backseat_scared'));
        daveScared.antialiasing = false;
        daveScared.scrollFactor.set(0.8, 1);
        daveScared.scale.set(0.4, 0.4);
        daveScared.updateHitbox();
        floatingGroup.add(daveScared);
        setDirection(randomDirection, 1, daveScared);
        
        randomDirection = directions[FlxG.random.int(0, directions.length - 1)];

        bfScared = new FlxSprite(750, 425);
        bfScared.frames = Paths.getSparrowAtlas('backgrounds/tristanBackseat/BF_Scared');
        bfScared.animation.addByPrefix('idle', 'BF idle shaking', 24);
        bfScared.animation.play('idle', true);
        bfScared.scrollFactor.set(0.8, 1);
        bfScared.scale.set(0.4, 0.4);
        bfScared.updateHitbox();
        floatingGroup.add(bfScared);
        setDirection(randomDirection, 2, bfScared);
        
        floatingCharsInitalized = true;
    }

    function changeFloatingCharsTo3D():Void
    {
        bfScared.loadGraphic(Paths.image('backgrounds/tristanBackseat/3d_bf_backseat'));
        bfScared.scale.set(0.4, 0.4);
        bfScared.updateHitbox();

        gfScared.loadGraphic(Paths.image('backgrounds/tristanBackseat/gf_3d_backseat'));
        gfScared.scale.set(0.4, 0.4);
        gfScared.updateHitbox();
    }

    function setDirection(dir:String, index:Int, sprite:FlxSprite)
    {
        sprite.velocity.x = FlxG.random.float(50, 100) * (dir == 'left' ? 1 : -1);
        sprite.angularVelocity = FlxG.random.float(-30, 30);

        floatingInfo.insert(index, dir);
    }

    function switchDirection(index:Int)
    {
        var curDirection:String = floatingInfo[index];
        var floatingChar = floatingGroup.members[index];

        floatingInfo[index] = (curDirection == 'left' ? 'right' : 'left');

        floatingChar.y = FlxG.random.float(250, 350);
        floatingChar.velocity.x = FlxG.random.float(50, 150) * FlxG.random.float(1, 2.5) * (floatingInfo[index] == 'left' ? 1 : -1);
        floatingChar.velocity.y = FlxG.random.float(-25, 50);
        
        floatingChar.angle = FlxG.random.float(-5, 5);
        floatingChar.angularVelocity = FlxG.random.float(-30, 30);
    }
}