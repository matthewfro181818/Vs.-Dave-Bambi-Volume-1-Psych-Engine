-- Converted from DB v1.0.6 HXC
class SwitchBaldiRoofs extends SongModule
{
    public function new()
    {
        super('switchBaldiRoofs', 0, 'roofs');
    }

    override function onCreate(e:ScriptEvent)
    {
        // Switch the baldi character.
        if (CharacterSelect.selectedCharacter == 'bf-3d')
        {
            game.dadOverride = 'baldi-3d';
        }
    }
}