package sheltie
{
	import org.flixel.FlxGame;
	
	import sheltie.objects.*;
	
	[SWF(width="640", height="384", frameRate="30")]
	public class sheltie extends FlxGame
	{
		public function sheltie()
		{
			super(320, 192, PlayState, 2, 60, 30);
			
			var using:Array = [
				HeroGoal, HeroSpawn, Hero, Item
			];
		}
	}
}