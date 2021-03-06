package sheltie
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	import sheltie.objects.GameObject;
	import sheltie.objects.Hero;

	public class GameManager
	{
		private static var _instance:GameManager = null;
		public static function instance():GameManager {
			if (_instance == null) {
				_instance = new GameManager();
				_instance.initialize();
			}
			return _instance;
		}
		
		public var player:Player;
		public var levelObjects:FlxGroup;
		public var mapObjects:FlxGroup;
		public var spriteObjects:FlxGroup;
		public var heroes:Array = [];
		public var currentLevel:Level;
		public var map:FlxTilemap;
		public var tileObjects:Object = {};
		public var uiObjects:FlxGroup;
		
		public function GameManager()
		{
		}
		
		public function initialize():void
		{
			levelObjects = new FlxGroup(4);
			mapObjects = new FlxGroup();
			spriteObjects = new FlxGroup();
			uiObjects = new FlxGroup();
			
			player = new Player();
			
			levelObjects.add(mapObjects);
			levelObjects.add(spriteObjects);
			levelObjects.add(player);
			levelObjects.add(uiObjects);
		}
		
		public function register(obj:FlxBasic, category:String = "None"):void
		{
			spriteObjects.add(obj);
		}
		
		public function registerTemporary(obj:FlxBasic):void
		{
			spriteObjects.add(obj);
			
			var timer:Timer = new Timer(0.01, 1);
			timer.addEventListener(TimerEvent.TIMER, function(eve:TimerEvent):void {
				obj.kill();
				timer.stop();
			});
			timer.start();
		}
		
		public function registerHero(obj:Hero):void
		{
			register(obj);
			heroes.push(obj);
		}
		
		public function registerUI(obj:FlxBasic):void
		{
			uiObjects.add(obj);
		}
		
		public function registerTileObject(obj:FlxBasic, coords:FlxPoint):void
		{
			if (!tileObjects[coords.y * map.widthInTiles + coords.x]) {
				tileObjects[coords.y * map.widthInTiles + coords.x] = [obj];
			} else {
				tileObjects[coords.y * map.widthInTiles + coords.x].push(obj);
			}
		}
		
		public function playLevel(levelname:String):void
		{
			currentLevel = Level.load(levelname);
			map = currentLevel.map;
			
			mapObjects.add(currentLevel.map);
		}
		
		public function getTileInfo(coord:FlxPoint, dir:Array = null):Object
		{
			var info:Object = {};
			
			if (coord.x < 0 || coord.x >= map.widthInTiles || coord.y < 0 || coord.y >= map.heightInTiles) {
				info['tile'] = 10;
				info['difficulty'] = 10;
				
				return info;
			}
			
			info['tile'] = map.getTile(coord.x, coord.y);
			info['tileObjects'] = tileObjects[coord.y * map.widthInTiles + coord.x];
			
			var diff:int = tileDifficulty(info['tile']);
			info['tile'] = diff;
			
			if (info['tileObjects']) {
				for each (var tobj:Object in info['tileObjects']) {
					diff += tobj.getTileDifficulty(dir);
				}
			}
			
			info['difficulty'] = diff;
			
			return info;
		}
		
		private function tileDifficulty(tile:uint):uint
		{
			switch (tile) {
				case 0:
					return 6;
				case 1:
					return 0;
				case 2:
					return 1;
				case 3:
					return 8;
				case 4:
					return 1;
				case 5:
					return 6;
			}
			return 1;
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