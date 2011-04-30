package sheltie
{
	import org.flixel.FlxGame;
	
	[SWF(width="640", height="360", frameRate="30")]
	public class sheltie extends FlxGame
	{
		public function sheltie()
		{
			super(640, 360, PlayState, 1, 60, 30);
		}
	}
}