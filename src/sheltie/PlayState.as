package sheltie
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
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
			GameManager.instance().playLevel("tiny.sheltie");
			this.add(GameManager.instance().levelObjects);
		}
	}
}