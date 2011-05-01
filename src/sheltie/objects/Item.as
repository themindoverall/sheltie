package sheltie.objects
{
	import org.flixel.FlxSprite;
	
	public class Item extends FlxSprite
	{
		public function Item(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
		}
	}
}