package sheltie.objects
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	import sheltie.GameManager;
	import sheltie.ResourceLoader;

	public class HeroSpawn extends GameObject
	{
		private var sprite:FlxSprite;
		private var c:int;
		private var timer:Number, cooldown:Number;
		
		public function HeroSpawn(objdata:Object)
		{
			sprite = createSprite(objdata);
			c = 1//objdata.props["count"];
			
			GameManager.instance().register(this);
			
			cooldown = parseFloat(objdata.props.rate) * 20 * 0.001;
			timer = cooldown;
		}
		
		public override function update():void {
			if (c <= 0) {
				return;
			}
			timer -= FlxG.elapsed;
			
			if (timer <= 0) {
				var hero:Hero = new Hero(sprite.x, sprite.y, ResourceLoader.get("chars1.png"));
				GameManager.instance().registerHero(hero);
				c--;
				
				timer = cooldown;
			}
		}
	}
}