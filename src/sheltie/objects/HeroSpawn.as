package sheltie.objects
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.FlxSprite;
	
	import sheltie.GameManager;
	import sheltie.ResourceLoader;

	public class HeroSpawn extends GameObject
	{
		private var sprite:FlxSprite;
		
		public function HeroSpawn(objdata:Object)
		{
			sprite = createSprite(objdata);
			//super(objdata, objCallback);
			
			var timer:Timer = new Timer(parseFloat(objdata.props.rate) * 20);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		public function onTimer(eve:TimerEvent):void {
			var hero:Hero = new Hero(sprite.x, sprite.y, ResourceLoader.get("chars1"));
			GameManager.instance().register(hero);
		}
	}
}