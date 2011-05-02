package sheltie.objects
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import sheltie.GameManager;
	import sheltie.ResourceLoader;

	public class GameObject extends FlxBasic
	{
		public function GameObject()
		{
			
		}
		
		public function createSprite(objdata:Object):FlxSprite
		{
			var img:Object = objdata.libobj.image;
			var pos:FlxPoint = GameManager.instance().map2position(new FlxPoint(objdata.pos[0], objdata.pos[1]));
			var sprite:FlxSprite = new FlxSprite(pos.x, pos.y);
			sprite.loadGraphic(ResourceLoader.get(img.src),false, false, img.width, img.height);
			sprite.frame = img.frame;
			GameManager.instance().register(sprite);
			return sprite;
		}
	}
}