-- Converted from DB v1.0.6 HXC
import play.character.CharacterType;

class InsanityEvents extends SongModule
{
    var redBg:VoidBGSprite;
    var dave3d:Character;

    public function new()
    {
        super('insanityEvents', 1, 'insanity');
    }

    override function onCreate(e:ScriptEvent):Void
    {
        if (PlayStatePlaylist.isStoryMode)
        {
            game.startCallback = () -> {
                game.beginStartDialogue('insanity', game.startCountdown);
            }
            game.endCallback = () -> {
                game.endSongDialogue('insanity-endDialogue', game.nextSong);
            }
        }
        Preloader.cacheImage(Paths.imagePath('backgrounds/void/redsky'));
    }

    override function onCreatePost(e:ScriptEvent):Void
    {
        redBg = new VoidBGSprite('bg', -1100, -500, Paths.image('backgrounds/void/redsky_insanity'));
        redBg.scale.set(1.5, 1.5);
        redBg.updateHitbox();
        redBg.alpha = 0.0001;
        redBg.zIndex = game.gf.zIndex - 1;
        game.currentStage.add(redBg);

        dave3d = Character.create(0, 350, 'dave-angey', CharacterType.OTHER);
        dave3d.alpha = 0.01;
        dave3d.zIndex = game.dad.zIndex;
        dave3d.reposition();
        game.currentStage.add(dave3d, CharacterType.OTHER, dave3d.getPosition());   
    }
    
    function onStepHit()
    {
        switch (e.step)
        {
            case 384, 1040:
                game.defaultCamZoom = 0.9;
            case 448, 1056:
                game.defaultCamZoom = 0.8;
            case 512:
                game.defaultCamZoom = 1;
            case 640:
                game.defaultCamZoom = 1.1;
            case 660, 680:
                SoundController.play(Paths.sound('static'), 0.1);
                game.dad.alpha = 0.0001;
                dave3d.alpha = 1;
                game.iconP2.char = dave3d.characterIcon;
                
                redBg.alpha = 1;
            case 664, 684:
                game.dad.alpha = 1;
                dave3d.alpha = 0.0001;
                game.iconP2.char = game.dad.characterIcon;
                
                redBg.alpha = 0.0001;
            case 708:
                game.defaultCamZoom = 0.8;
                game.dad.playAnim('um', true);
                game.dad.canDance = false;
            case 768:
                game.defaultCamZoom = 0.7;
                game.camGame.overrideFollowPoint = new FlxPoint(game.gf.cameraFocusPoint.x, game.gf.cameraFocusPoint.y);
            case 784:
                game.defaultCamZoom = 0.9;
                game.camGame.overrideFollowPoint = null;
                game.dad.canDance = true;
            case 1176:
                SoundController.play(Paths.sound('static'), 0.1);
                redBg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
                redBg.setPosition(-1400, -800);
                dave3d.alpha = 1;
                game.dad.alpha = 0.0001;
                redBg.alpha = 1;
                game.iconP2.char = dave3d.characterIcon;
            case 1180:
                game.dad.alpha = 1;
                dave3d.alpha = 0;
                game.iconP2.char = game.dad.characterIcon;
                game.dad.canDance = false;
                game.dad.playAnim('scared', true);
                game.dad.animation.onFinish.addOnce(function(anim:String) {
                    if (anim == 'scared') {
                        game.dad.playAnim('scaredLoop', true);
                    }
                });
        }
    }

    override function onOpponentNoteHit(e:NoteScriptEvent):Void
    {
        super.onOpponentNoteHit(e);
        
        dave3d.sing(e.note.direction);
    }
}