package sheltie.objects
{
	import sheltie.ResourceLoader;

	public class SignItem extends Item
	{
		public var dir:Array;
		
		public function SignItem(dirnum:int)
		{
			super();
			
			this.loadGraphic(ResourceLoader.get("signs.png"), false, false, 16, 16);
			this.setOriginToCorner();
			
			this.dir = numtodir(dirnum);
			this.frame = dirnum;
		}
		
		public function numtodir(dirnum:int):Array
		{
			switch (dirnum) {
				case 0:
					return [1, 0];
				case 1:
					return [-1,0];
				case 2:
					return [0,-1];
				case 3:
					return [0, 1];
				
			}
			
			return [1, 0];
		}
	}
}