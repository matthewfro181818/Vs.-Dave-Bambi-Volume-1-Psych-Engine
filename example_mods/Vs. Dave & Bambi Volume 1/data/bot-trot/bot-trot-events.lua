-- Converted from DB v1.0.6 HXC
import flixel.math.FlxMath;
import flixel.math.FlxBasePoint;
import play.character.CharacterType;

enum BGType
{
    Room; Studio; Matrix;
}
class BotTrotEvents extends SongModule
{
    var curBg:BGType = BGType.Room;

    var greyscaleAmt:Float = 0.25;
    var normal:Array<Float> = [
        1, 0, 0, 0, 0,
        0, 1, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 0, 0, 1, 0
    ];
    var dark:Array<Float> = [
        0.7, 0, 0, 0, 0,
        0, 0.7, 0, 0, 0,
        0, 0, 0.7, 0, 0,
        0, 0, 0, 0.7, 0
    ];
    var sepia:Array<Float> = [
        0.44, 0.44, 0.44, 0, 0,
        0.26, 0.26, 0.26, 0, 0,
        0.08, 0.08, 0.08, 0, 0,
        0, 0, 0, 1, 0
    ];
    var colorMatrixShader:ColorMatrixFilter = new ColorMatrixFilter();

    var blackHUD:FlxSprite;
    var blackGame:FlxSprite;

    var vignette:FlxSprite;

    var normalStage:Stage;
    var studioStage:Stage;
    var matrixStage:Stage;

    var playrobotNormal:Character;
    var playrobotStudio:Character;
    var bfGhost:Character;

    var bfSingTimer:FlxTimer = null;

    var MATRIX_COLORS:Array<FlxColor> = [FlxColor.GREEN, FlxColor.BLUE, FlxColor.LIME, FlxColor.CYAN];
    var matrixColorIndex = 0;

    var alphaEcho:Float = 1;
    var echoOffset:Float = 0.9;
    var canFadeNotes:Bool = false;

    public function new()
    {
        super('botTrotEvents', 0, 'bot-trot');
    }

    function onCreatePost(e:ScriptEvent)
    {	
        game.defaultCamZoom -= 0.1;
        
        normalStage = game.currentStage;

        matrixStage = game.loadStage('matrix');
        matrixStage.scrollFactor.set();
        matrixStage.visible = false;
        game.add(matrixStage);
        
        studioStage = StageRegistry.instance.fetchEntry('music-studio');
        if (studioStage != null)
        {
            if (!studioStage.alive)
            {
                studioStage.revive();
            }
            studioStage.revive();
            studioStage.load();
            studioStage.visible = false;
            game.add(studioStage);
        }

        playrobotNormal = game.dad;

        playrobotStudio = Character.create(game.dad.x, game.dad.y, 'playrobot-studio');
        playrobotStudio.alpha = 0.0001;
        game.currentStage.addCharacter(playrobotStudio, CharacterType.OPPONENT, playrobotStudio.getPosition(), false);
        
        bfGhost = Character.create(0, 0, game.boyfriend.id, CharacterType.PLAYER);
        bfGhost.scrollFactor.set();
        bfGhost.cameras = [game.camHUD];
        bfGhost.setScale(2, 2);
        bfGhost.alpha = 0.3;
        bfGhost.zIndex = 500;
        game.add(bfGhost);
        
        bfGhost.dance();
        bfGhost.x = -bfGhost.width;
        bfGhost.y = (FlxG.height - bfGhost.height) / 2;
        bfGhost.visible = false;
        bfGhost.flip();
        bfGhost.offsetScale = 2;

    }
    function onCreateUI(e:ScriptEvent)
    {	
        blackHUD = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        blackHUD.scale.set(FlxG.width * 2, FlxG.height * 2);
        blackHUD.updateHitbox();
        blackHUD.screenCenter();
        blackHUD.cameras = [game.camHUD];
        blackHUD.alpha = 0.999;
        game.add(blackHUD);
        
        blackGame = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        blackGame.scale.set(FlxG.width * 4, FlxG.height * 4);
        blackGame.updateHitbox();
        blackGame.screenCenter();
        blackGame.alpha = 0.00001;
        game.add(blackGame);
        
        vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
        vignette.setGraphicSize(FlxG.width + 5, FlxG.height + 5);
        vignette.updateHitbox();
        vignette.screenCenter();
        vignette.scrollFactor.set();
        vignette.cameras = [game.camHUD];
        vignette.alpha = 0;
        vignette.color = FlxColor.BLACK;
        game.add(vignette);
    }

    function onUpdate(e:UpdateScriptEvent)
    {
        if (canFadeNotes) {
            alphaEcho -= (1 / (Conductor.instance.measureLength / 1000) * echoOffset) * e.elapsed;
            alphaEcho = FlxMath.bound(alphaEcho, 0, 1);
            
            game.playerStrums.forEachNote(function(note:Note) {
                if (note == null)
                    continue;
                
                note.alphaModifier = alphaEcho;
            });
        }
    }

    function onDestroy(e:ScriptEvent)
    {
        game.removeStage(studioStage);
        game.removeStage(matrixStage);
    }

    function onSongStart(e:ScriptEvent)
    {
        colorMatrixShader.matrix = getGreyscale();
        game.camGame.filters = [colorMatrixShader];
        game.camHUD.filters = [colorMatrixShader];

        tweenMatrix(normal, (Conductor.instance.stepCrochet / 1250) * 110, FlxEase.quadIn);
        
        FlxTween.tween(blackHUD, {alpha: 0}, (Conductor.instance.stepCrochet / 1250) * 110, {ease: FlxEase.quadIn});
        FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom + 0.2}, (Conductor.instance.stepCrochet / 1250) * 110, {ease: FlxEase.quadIn});
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 112:
                game.defaultCamZoom += 0.2;
                
                game.camGame.setFollow(game.dad.cameraFocusPoint.x, game.dad.cameraFocusPoint.y);
                game.camGame.lockTarget = true;
                game.forceFocusOnChar = true;
                
                game.dad.canDance = false;
                game.dad.playAnim('game', true);
                game.dad.animation.onFinish.addOnce(function(anim:String) {
                    game.dad.canDance = true;
                    game.dad.dance();
                });
            case 128:
                game.defaultCamZoom -= 0.2;
                game.camGame.lockTarget = false;
                game.forceFocusOnChar = false;
            case 256:
                game.defaultCamZoom += 0.1;
            case 384, 896:
                game.defaultCamZoom = 0.65;
                if (e.step == 896) {
                    game.camGame.lockTarget = false;
                    game.forceFocusOnChar = false;
                    FlxTween.tween(vignette, {alpha: 0.8}, 0.5);
                } else {
                    game.camHUD.filters = [];
                    FlxTween.tween(vignette, {alpha: 1}, 0.5);
                }
            case 512:
                game.defaultCamZoom = 0.8;
                tweenMatrix(dark, 0.5, FlxEase.backOut);
                FlxTween.tween(vignette, {alpha: 0}, 0.5);
            case 640:
                game.defaultCamZoom = 0.7;
            case 768, 832:
                game.defaultCamZoom = 0.9;
            case 800:
                game.defaultCamZoom -= 0.2;
            case 864:
                game.defaultCamZoom = 0.65;

                game.camGame.setFollow(game.boyfriend.cameraFocusPoint.x - 250, game.boyfriend.cameraFocusPoint.y);
                game.camGame.lockTarget = true;
                game.forceFocusOnChar = true;
            case 1024:
                tweenMatrix(normal, 0.5, FlxEase.backOut);
                FlxTween.tween(vignette, {alpha: 0}, 0.5);
            case 1088:
                FlxTween.tween(blackHUD, {alpha: 1}, 0.5, {onComplete: function(tween:FlxTween) {
                    FlxG.camera.zoom = game.defaultCamZoom = 0.7;
                    switchToStudio();
                    
                    colorMatrixShader.matrix = sepia;
                    
                    game.boyfriend.canDance = false;
                    
                    super.bfSingTimer = new FlxTimer().start(0, function(t:FlxTimer) 
                    {
                        game.boyfriend.sing(FlxG.random.int(0, 3));
                        super.bfSingTimer.reset(0.1);
                    });
                }});
            case 1106:
                FlxTween.tween(blackHUD, {alpha: 0}, 0.5);
                game.camHUD.filters = [colorMatrixShader];
            case 1130:
                super.bfSingTimer.cancel();
                game.boyfriend.sing(1, true);
            case 1134:
                game.dad.canDance = false;
                game.dad.playAnim('messedUp', true);
                game.dad.animation.onFinish.addOnce(function(anim:String) {
                    game.dad.canDance = true;
                    game.dad.dance();
                    
                    game.boyfriend.canDance = true;
                });
            case 1408:
                game.defaultCamZoom += 0.1;
                FlxTween.tween(vignette, {alpha: 0.6}, 0.5);
            case 1600:
                transitionToMatrix();
            case 1664:
                tweenMatrix(normal, 0.5, FlxEase.quadIn);
                FlxTween.tween(blackHUD, {alpha: 0}, 0.5);
                FlxTween.tween(vignette, {alpha: 0}, 0.5);
                
                switchToMatrix();
            case 1824:
                FlxTween.tween(game.timer, {x: game.timer.x - 300}, 1, {ease: FlxEase.sineInOut});
                for (i in 0...game.playerStrums.strums.members.length) {
                    var strum = game.playerStrums.strums.members[i];
                    FlxTween.tween(strum, {x: strum.centerX}, 1, {ease: FlxEase.sineInOut, startDelay: 0.25 + (i * 0.05)});
                }
                FlxTween.tween(game.ratings, {x: game.ratings.x - 200}, 1, {ease: FlxEase.sineInOut});
            case 1844:
                canFadeNotes = true;
            case 1884, 1924, 1964, 2004, 2044, 2084, 2104, 2124, 2144:
                switchMatrixColors();
            case 2164:
                canFadeNotes = false;
                game.playerStrums.forEachNote(function(note:Note) {
                    if (note == null)
                        continue;
                    
                    note.copyAlpha = true;
                    note.alphaModifier = 1;
                });
                game.playerStrums.recyclableNotes.forEach(function(note:Note) {
                    if (note == null)
                        continue;
                    
                    note.copyAlpha = true;
                    note.alphaModifier = 1;
                });
	
                game.camZooming = false;
                bfGhost.visible = true;
                FlxTween.tween(bfGhost, {x: FlxG.width}, (Conductor.instance.stepCrochet * 140) / 1000, {onComplete: function(t:FlxTween) {
                    bfGhost.visible = false;
                }});
            case 2324:
                switchBackToRoom();
        }
    }

    function onMeasureHit(e:ConductorScriptEvent)
    {
        alphaEcho = 1;
    }

    function onNoteSpawn(e:NoteScriptEvent)
    {
        if (canFadeNotes) {
            e.note.copyAlpha = false;
        }
    }

    function onPlayerNoteHit(e:NoteScriptEvent)
    {
        bfGhost.sing(e.note.direction);
    }

    function onNoteMiss(e:NoteScriptEvent)
    {
        bfGhost.sing(e.note.direction, true);
    }

    function onCameraMove(e:CameraScriptEvent)
    {
        switch (curBg) {
            case BGType.Studio:
                if (!e.isOpponent) {
                    game.camGame.followPoint.y = game.dad.cameraFocusPoint.y;
                }
            case BGType.Matrix:
                game.camGame.setFollow(game.boyfriend.cameraFocusPoint.x + 100, game.boyfriend.cameraFocusPoint.y);
        }
    }

    function tweenMatrix(toMatrix:Array<Float>, time:Float, ease:FlxEase)
    {
        var matrix = colorMatrixShader.matrix;
        
        for (i in 0...matrix.length) {
            FlxTween.num(matrix[i], toMatrix[i], time, {ease: ease}, function(num:Float) {
                matrix[i] = num;
                
                colorMatrixShader.matrix = matrix;
            });
        }
    }

    function getGreyscale():Array<Float>
    {
        return [
            greyscaleAmt, greyscaleAmt, greyscaleAmt, 0, 0,
            greyscaleAmt, greyscaleAmt, greyscaleAmt, 0, 0,
            greyscaleAmt, greyscaleAmt, greyscaleAmt, 0, 0,
            0, 0, 0, 1, 0
        ];
    }
    function switchToStudio()
    {
        curBg = BGType.Studio;
        
        game.currentStage.moveCharactersToStage(studioStage);
        game.currentStage = studioStage;
        game.currentStage.visible = true;
        game.currentStage.alpha = 1;
        
        game.dad = playrobotStudio;
        playrobotStudio.alpha = 1;
        playrobotNormal.alpha = 0;

        normalStage.visible = false;
        normalStage.alpha = 0;
        game.gf.visible = false;
    }

    function switchToMatrix()
    {
        matrixStage.visible = true;

        FlxTween.tween(matrixStage, {alpha: 1}, (Conductor.instance.stepCrochet / 1000) * 160);
    }

    function transitionToMatrix()
    {
        matrixStage.visible = true;
        matrixStage.alpha = 0;

        game.camMoveOnNoteAllowed = false;
        var transitionTime = (Conductor.instance.stepCrochet / 1000) * 224;
        curBg = BGType.Matrix;

        for (i in [game.dad, game.gf])
        {
            FlxTween.tween(i, {alpha: 0}, transitionTime);
        }
        for (i in game.dadStrums.strums)
        {
            FlxTween.tween(i, {alpha: 0}, transitionTime);
        }

        for (i in MapTools.values(studioStage.namedProps))
        {
            FlxTween.tween(i, {alpha: 0}, transitionTime);
        }

        FlxTween.tween(game.iconP2, {alpha: 0}, transitionTime);
        
        FlxTween.num(0, 1, transitionTime, {ease: FlxEase.linear}, function(num:Float) {
            var newColor = FlxColor.interpolate(game.dad.characterColor, game.boyfriend.characterColor, num);
            
            game.timer.updatePieColor(newColor);
            game.healthBar.bar.createFilledBar(newColor, game.boyfriend.characterColor);
            game.healthBar.bar.updateBar();
        });
        
        var curZoom:Float = game.defaultCamZoom;
        FlxTween.tween(game, {defaultCamZoom: curZoom - 0.2}, transitionTime);
    }
    function switchBackToRoom()
    {
        curBg = BGType.Room;
        
        game.defaultCamZoom = 0.7;

        game.dad = playrobotNormal;
        game.dad.canDance = false;
        game.dad.canSing = false;
        game.dad.playAnim('confused', true);
        
        game.currentStage = normalStage;

        normalStage.visible = true;
        normalStage.alpha = 1;

        game.gf.visible = true;
        studioStage.moveCharacterToStage(game.dad, normalStage, FlxBasePoint.get(100, 425));
        studioStage.moveCharacterToStage(game.gf, normalStage, FlxBasePoint.get(275, 130));
        studioStage.moveCharacterToStage(game.boyfriend, normalStage, game.boyfriend.getPosition(), false);

        var transitionTime:Float = 1;
        
        FlxTween.tween(matrixStage, {alpha: 0}, transitionTime);
        for (i in [game.dad, game.gf])
        {
            FlxTween.tween(i, {alpha: 1}, transitionTime);
        }

        for (i in game.dadStrums.strums)
        {
            FlxTween.tween(i, {alpha: 1}, transitionTime);
        }

        FlxTween.tween(game.iconP2, {alpha: 1}, transitionTime);
                
        FlxTween.num(0, 1, transitionTime, {ease: FlxEase.linear}, function(num:Float) {
            var newColor = FlxColor.interpolate(game.boyfriend.characterColor, game.dad.characterColor, num);

            game.timer.updatePieColor(newColor);
            game.healthBar.bar.createFilledBar(newColor, game.boyfriend.characterColor);
            game.healthBar.bar.updateBar();
        });
        
        FlxTween.tween(game.timer, {x: game.timer.x + 300}, 1, {ease: FlxEase.sineInOut});
        FlxTween.tween(game.ratings, {x: game.ratings.x + 200}, 1, {ease: FlxEase.sineInOut});

        for (i in 0...game.playerStrums.strums.members.length)
        {
            var strum = game.playerStrums.strums.members[i];
            FlxTween.tween(strum, {x: strum.baseX}, 1, {ease: FlxEase.sineInOut, startDelay: (i * 0.05)});
        }
    }

    function switchMatrixColors()
    {
        matrixColorIndex = (matrixColorIndex + 1 > MATRIX_COLORS.length - 1) ? 0 : matrixColorIndex + 1;       
        matrixStage.scriptCall('switchColors', [MATRIX_COLORS[matrixColorIndex]]);
    }
}