package sheltie.objects
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import sheltie.GameManager;
	
	public class Hero extends FlxSprite
	{
		public var dir:Array = [-1, 0];
		
		public function Hero(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			
			this.makeGraphic(16, 16, 0xFFFFFFFF);
		}
		
		public override function update():void
		{
			var temp:int;
			this.x += 20 * dir[0] * FlxG.elapsed;
			this.y += 20 * dir[1] * FlxG.elapsed;
			
			if (checktile(dir[0] * (width / 2.0), dir[1] * (height / 2.0)) != 1) { // front
				if (checktile(dir[1] * width, -dir[0] * height) != 1) { //right
					if (checktile(-dir[1] * width, dir[0] * height) != 1) {// left
						// turn around.
						dir[0] = -dir[0];
						dir[1] = -dir[1];
					} else {
						// turn left
						temp = dir[0];
						dir[0] = -dir[1];
						dir[1] = temp;
					}
				} else {
					// turn right.
					
					temp = dir[0];
					dir[0] = dir[1];
					dir[1] = -temp;
				}
			}
			
		}
		
		private function checktile(offx:int, offy:int):uint
		{
			var coords:FlxPoint = GameManager.instance().position2map(new FlxPoint(x + offx,y + offy));
			return GameManager.instance().currentLevel.map.getTile(coords.x, coords.y);
		}
	}
}