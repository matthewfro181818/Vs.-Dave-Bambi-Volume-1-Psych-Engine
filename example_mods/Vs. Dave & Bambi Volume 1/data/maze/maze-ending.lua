-- Converted from DB v1.0.6 HXC
class MazeEnding extends SongModule
{
    public function new()
    {
        super('mazeEnding', 0, 'maze');
    }

    function onCreate(e:ScriptEvent)
    {
        if (!PlayStatePlaylist.isStoryMode) {
            return;
        }
        
        game.startCallback = () -> {
            game.beginStartDialogue('maze');
        }
        game.endCallback = function()
        {
            game.endSongDialogue('maze-endDialogue', function() {

                var score:Int = PlayStatePlaylist.campaignScore;
            
                var params:EndingStateParams = if (score >= 400000) {
                    {week: 'bambi', ending: 'good', song: 'goodEnding', anims: [{name: 'idle', prefix: 'good_bambi', loop: true}]}
                } else if (score >= 250000 && score < 400000) {
                    {week: 'bambi', ending: 'bad', song: 'badEnding', anims: [{name: 'idle', prefix: 'bad_bambi', loop: true}]}
                } else {
                    {week: 'bambi', ending: 'worst', song: 'badEnding', anims: [{name: 'idle', prefix: 'worst_bambi', loop: true}]}
                }
                FlxG.switchState(() -> new EndingState(params));
            });	
        }
    }
    
    function onNoteMiss(e:NoteScriptEvent)
    {
        if (Conductor.instance.curMeasure == 86 && PlayStatePlaylist.isStoryMode)
        {
            // The last phone note will take away 20% of your health.
            e.healthChange = 0.2 * 2;
            var willDie:Bool = (game.health - e.healthChange) <= 0;
            if (willDie && e.note.noteStyle == 'phone')
            {
                FlxG.switchState(() -> new EndingState({week: 'bambi', ending: 'phone', song: 'badEnding'}));
                e.cancel();
            }
        }
    }
}