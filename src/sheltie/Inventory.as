package sheltie
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import sheltie.objects.Item;

	public class Inventory extends FlxGroup
	{
		public var player:Player;
		private var selector:FlxSprite;
		private var items:FlxGroup;
		private var bg:FlxSprite;
		
		public var selecteditem:Item = null;
		
		public function Inventory(player:Player)
		{
			super();
		
			this.player = player;
			
			bg = new FlxSprite(0,0);
			
			bg.scrollFactor.make(0,0);
			bg.makeGraphic(60, FlxG.camera.height, 0x77000000);
			bg.setOriginToCorner();
			bg.x = FlxG.camera.width - 60;
			bg.y = 0;
			
			this.add(bg);
			
			items = new FlxGroup();
			this.add(items);
			
			selector = new FlxSprite();
			selector.loadGraphic(ResourceLoader.get("markers.png"),false, false, 16, 16);
			selector.setOriginToCorner();
			selector.scrollFactor.make(0,0);
			selector.x = FlxG.camera.width - 60 + 3;
			selector.y = 3;
			selector.frame = 1;
			this.add(selector);
		}
		
		public override function update():void
		{
			if (uiHandled(FlxG.mouse.screenX, FlxG.mouse.screenY) && FlxG.mouse.justPressed()) {
				var mx:int = FlxG.mouse.screenX - bg.x;
				var my:int = FlxG.mouse.screenY - bg.y;
				
				var idx:int = 100;
				
				for (var i:int = 0; i < items.length; i++) {
					var item:Item = items.members[i];
					if (item.overlapsPoint(new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY))) {
						selecteditem = item;
						idx = i;
						break;
					}
				}
				
				
				if (idx < items.length) {
					selector.x = selecteditem.x;
					selector.y = selecteditem.y;
				}
			}
		}
		
		public function uiHandled(mx:int, my:int):Boolean
		{
			return mx > FlxG.camera.width - 60;
		}
		
		public function addItem(item:Item):void
		{	
			var itemcount:int = items.length;
			if (itemcount == 0)
			{
				selecteditem = item;
			}
			
			item.x = FlxG.camera.width - 60 + 3 + ((itemcount % 3) * (16 + 4));
			item.y = 3 + (Math.floor(itemcount / 3) * (16 + 4));
			
			items.add(item);
		}
		
		public function useSelectedItem():void
		{
			items.remove(selecteditem, true);
			selecteditem = items.members[0];
			selector.x = selecteditem.x;
			selector.y = selecteditem.y;
		}
	}
}