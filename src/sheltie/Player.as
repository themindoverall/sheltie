package sheltie
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	
	import sheltie.objects.Hero;
	import sheltie.objects.Sign;

	public class Player extends FlxBasic
	{
		public static const CAM_SPEED:Number = 100;
		
		public var points:int = 0;
		
		public function Player()
		{
			FlxG.mouse.show();
		}
		
		public override function update():void
		{
			FlxG.camera.scroll.x += ((FlxG.keys.RIGHT ? 1 : 0) - (FlxG.keys.LEFT ? 1 : 0)) * CAM_SPEED * FlxG.elapsed;
			FlxG.camera.scroll.y += ((FlxG.keys.DOWN ? 1 : 0) - (FlxG.keys.UP ? 1 : 0)) * CAM_SPEED * FlxG.elapsed;
		
			if (FlxG.mouse.justPressed()) {
				var spcoord:FlxPoint = GameManager.instance().position2map(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
				var spos:FlxPoint = GameManager.instance().map2position(spcoord);
				
				var rand:int = int(Math.random() * 4);
				var dir:Array;
				switch (rand) {
					case 0:
						dir = [-1, 0];
						break;
					case 1:
						dir = [1, 0];
						break;
					case 2:
						dir = [0, -1];
						break;
					case 3:
						dir = [0, 1];
						break;
				}
				
				var sign:Sign = new Sign(spos.x, spos.y, dir);
				GameManager.instance().register(sign);
			}
		}
		
		public function score():void
		{
			points++;
		}
	}
}