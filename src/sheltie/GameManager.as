package sheltie
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	import sheltie.objects.GameObject;

	public class GameManager
	{
		private static var _instance:GameManager = null;
		public static function instance():GameManager {
			if (_instance == null) {
				_instance = new GameManager();
			}
			return _instance;
		}
		
		public var levelObjects:FlxGroup;
		public var mapObjects:FlxGroup;
		public var spriteObjects:FlxGroup;
		public var heroes:Array = [];
		public var currentLevel:Level;
		public var map:FlxTilemap;
		
		public function GameManager()
		{
			levelObjects = new FlxGroup(2);
			mapObjects = new FlxGroup();
			spriteObjects = new FlxGroup();
			
			levelObjects.add(mapObjects);
			levelObjects.add(spriteObjects);
		}
		
		public function register(obj:FlxBasic):void
		{
			spriteObjects.add(obj);
		}
		
		public function playLevel(levelname:String):void
		{
			currentLevel = Level.load(levelname);
			map = currentLevel.map;
			
			mapObjects.add(currentLevel.map);
		}
		
		public function position2map(pos:FlxPoint):FlxPoint
		{
			return new FlxPoint(Math.floor(pos.x / 16), Math.floor(pos.y / 16));
		}
		
		public function map2position(coord:FlxPoint):FlxPoint
		{
			return new FlxPoint(coord.x * 16 + 8, coord.y * 16 + 8);
		}
	}
}