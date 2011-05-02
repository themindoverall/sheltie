package sheltie.objects
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import sheltie.GameManager;
	import sheltie.ResourceLoader;
	
	public class Sign extends FlxSprite
	{
		public var dir:Array;
		public var coord:FlxPoint;
		public function Sign(X:Number=0, Y:Number=0, dir:Array = null)
		{
			super(X, Y);
			
			this.loadGraphic(ResourceLoader.get("signs.png"), false, false, 16, 16);
			
			this.dir = [dir[0], dir[1]];
			
			switch (dir[0] + 2*dir[1]) {
				case -1: // left
					this.frame = 1;
					break;
				case -2: // up
					this.frame = 2;
					break;
				case 1: // right
					this.frame = 0;
					break;
				case 2: // down
					this.frame = 3;
					break;
			}
			
			var coord:FlxPoint = GameManager.instance().position2map(new FlxPoint(x, y));
			this.coord = new FlxPoint(coord.x, coord.y);
			coord.x += dir[0];
			coord.y += dir[1];
			
			//var cpos:FlxPoint = GameManager.instance().map2position(coord);

				//var spr:FlxSprite = new FlxSprite(cpos.x, cpos.y);
				//spr.makeGraphic(3,3);
				//GameManager.instance().register(spr);
			
			GameManager.instance().registerTileObject(this, coord);
		}
		
		public override function update():void
		{			
			for each (var hero:Hero in GameManager.instance().heroes) {
				if (FlxU.getDistance(new FlxPoint(hero.x, hero.y), new FlxPoint(x,y)) < 3.0) {
					hero.dir[0] = this.dir[0];
					hero.dir[1] = this.dir[1];
				}
			}
		}
		
		public function getTileDifficulty(dir:Array):int
		{
			//trace('and', from.x, from.y,'-', coord.x,coord.y);
			if (dir[0] == this.dir[0] && dir[1] == this.dir[1]) {
				return -2;
			} else {
				return 0;
			}
		}
	}
}