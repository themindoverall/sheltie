package sheltie
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	
	import sheltie.objects.Hero;
	import sheltie.objects.Sign;
	import sheltie.objects.SignItem;

	public class Player extends FlxBasic
	{
		public static const CAM_SPEED:Number = 100;
		
		public var points:int = 0;
		public var inventory:Inventory;
		
		public function Player()
		{
			FlxG.mouse.show();
			
			inventory = new Inventory(this);
			inventory.addItem(new SignItem(2));
			inventory.addItem(new SignItem(3));
			inventory.addItem(new SignItem(1));
			inventory.addItem(new SignItem(0));
			GameManager.instance().registerUI(inventory);
		}
		
		public override function update():void
		{
			//FlxG.camera.scroll.x += ((FlxG.keys.RIGHT ? 1 : 0) - (FlxG.keys.LEFT ? 1 : 0)) * CAM_SPEED * FlxG.elapsed;
			//FlxG.camera.scroll.y += ((FlxG.keys.DOWN ? 1 : 0) - (FlxG.keys.UP ? 1 : 0)) * CAM_SPEED * FlxG.elapsed;
		
			if (!inventory.uiHandled(FlxG.mouse.screenX, FlxG.mouse.screenY) && FlxG.mouse.justPressed()) {
				var spcoord:FlxPoint = GameManager.instance().position2map(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
				var spos:FlxPoint = GameManager.instance().map2position(spcoord);
				
				var rand:int = int(Math.random() * 4);
				var dir:Array = (inventory.selecteditem as SignItem).dir;
				
				inventory.useSelectedItem();
				
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