-- Converted from DB v1.0.6 HXC
class HouseDialogue extends SongModule
{
    function new()
    {
        super('houseDialogue', 0, 'house');
    }

    function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {
            game.startCallback = () -> {
                game.beginStartDialogue('house');
            }
        }
    }
}