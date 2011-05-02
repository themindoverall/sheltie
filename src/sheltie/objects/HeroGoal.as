package sheltie.objects
{	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import sheltie.GameManager;

	public class HeroGoal extends GameObject
	{
		private var sprite:FlxSprite;
		
		public function HeroGoal(objdata:Object)
		{
			sprite = createSprite(objdata);
			
			GameManager.instance().register(this);
		}
		
		public override function update():void
		{
			for each (var hero:Hero in GameManager.instance().heroes) {
				if (FlxU.getDistance(sprite.getMidpoint(), hero.getMidpoint()) < 3.0) { //.collide(sprite, hero)) {
					hero.kill();
					GameManager.instance().player.score();
				}
			}
		}
	}
}