package sheltie
{
	import org.flixel.FlxState;
	
	public class PlayState extends FlxState
	{
		public var player:Player;
		public var heroes:Array;
		public var currentLevel:Level;
		
		public function PlayState()
		{
			super();
		}
		
		public override function create():void
		{
			player = new Player();
			
			currentLevel = new Level();
			
			heroes = [];
			
		}
	}
}