package sheltie.objects
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import sheltie.GameManager;
	
	public class Hero extends FlxSprite
	{
		public static const MOVE_SPEED:Number = 45.0;
		
		public var dir:Array = [-1, 0];
		private var puppet:Puppet;
		public var tol:int = 0;
		
		public function Hero(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			
			puppet = new Puppet(this, {
				"animations": {
					"stand": {
						0: [1],
						90: [19],
						180: [37],
						270: [55]
					},
					"walk": {
						0: [0, 1, 2, 1],
						90: [18, 19, 20, 19],
						180: [36, 37, 38, 37],
						270: [54, 55, 56, 55]
					}
				}
			});
			
			this.loadGraphic(SimpleGraphic, true, false, 16, 18);
		}
		
		public override function update():void
		{
			var temp:int;
			
			var mytile:int = (checktile(0,0, dir))['tile'];
			
			var angle:int = 0;
			if (dir[0] == -1) {
				angle = 270;
			} else if (dir[0] == 1) {
				angle = 90;
			} else if (dir[1] == -1) {
				angle = 0;
			} else {
				angle = 180;
			}
			
			puppet.play("walk", angle);
			
			var dirs:Array = [
				{
					drec: [0, -1]
				},
				{
					drec: [0, 1]
				},
				{
					drec: [-1, 0]
				},
				{
					drec: [1, 0]
				}];
			for (var i:int = 0; i < 4; i++) {
				var obj:Object = dirs[i];
				var ct:Object = checktile(obj.drec[0] * (18 / 2.0), obj.drec[1] * (18 / 2.0), obj.drec);
				obj.score = ct['difficulty'];
				obj.tile = ct['tile'];
			}
			
			dirs.sort(function(a:Object, b:Object):int {
				var masha:int = dir[0] * a.drec[0] + dir[1] * a.drec[1]; // 1 if they agree, -1 of they disagree
				var mashb:int = dir[0] * b.drec[0] + dir[1] * b.drec[1];
				
				if (masha > 0 && a.tile <= mytile) {
					return -1;
				} else if (mashb > 0 && b.tile <= mytile) {
					return 1;
				}
				
				if (a.score == b.score) {
					if (masha > mashb) {
						return -1;
					} else if (masha < mashb) {
						return 1;
					} else {
						var mashd:int = tilenum(dir);
						masha = tilenum(a.drec) - mashd;
						mashb = tilenum(b.drec) - mashd;
						
						if (masha < 0) {
							masha += 4;
						}
						if (mashb < 0) {
							mashb += 4;
						}
						
						if (masha == mashb) {
							throw new Error("masha == mashb");
						}
						
						if (masha < mashb) {
							return -1;
						} else {
							return 1;
						}
					}
					
					// will be 1 when they're the same.
					// will be -1 when they're opposite
					// will be 0 when they're perp
					
				} else if (a.score > b.score) {
					return 1;
				} else {
					return -1;
				}
			});
			
			if (dir[0] != dirs[0].drec[0] || dir[1] != dirs[0].drec[1])
			{	
				this.dir[0] = dirs[0].drec[0];
				this.dir[1] = dirs[0].drec[1];
			}
			
			this.x += MOVE_SPEED * dir[0] * FlxG.elapsed;
			this.y += MOVE_SPEED * dir[1] * FlxG.elapsed;
			if (dir[0] == 0) {
				this.x = Math.floor(this.x / 16) * 16 + 8;
			}
			if (dir[1] == 0) {
				this.y = Math.floor(this.y / 16) * 16 + 8;
			}
		}
		
		private function tilenum(t:Array):int
		{
			switch (t[0] + (2 * t[1])) {
				case -1: // left
					return 3;
				case -2: // up
					return 0;
				case 1: // right
					return 1;
				case 2: // down
					return 2;
			}
			
			throw new Error("UNKNOWN TILE NUMBER");
			return 0;
		}
		
		private function checktilecoord(offx:int, offy:int):int
		{
			var coords:FlxPoint = GameManager.instance().position2map(new FlxPoint(x,y));
			coords.x += offx;
			coords.y += offy;
			var tileinfo:Object = GameManager.instance().getTileInfo(coords);
			
			if (tileinfo['difficulty'] != 0) {
				//trace(tileinfo['difficulty']);
			}
			
			return tileinfo['difficulty'];
		}
		
		private function checktile(offx:int, offy:int, indir:Array):Object
		{
			var pt:FlxPoint = new FlxPoint(x + offx, y + offy);
			var from:FlxPoint = GameManager.instance().position2map(new FlxPoint(x,y));
			var coords:FlxPoint = GameManager.instance().position2map(pt);
			var tileinfo:Object = GameManager.instance().getTileInfo(coords, indir);
			var cpos:FlxPoint = GameManager.instance().map2position(coords);
			if (false) { //tileinfo['difficulty'] > 0) {
				var spr:FlxSprite = new FlxSprite(pt.x, pt.y);
				spr.makeGraphic(3,3);
				GameManager.instance().registerTemporary(spr);
			}
			//spr = new FlxSprite(cpos.x, cpos.y);
			//spr.makeGraphic(1,1, 0xffff0000);
			//GameManager.instance().registerTemporary(spr);
			if (tileinfo['difficulty'] != 0) {
				//trace(tileinfo['difficulty']);
			}
			
			return tileinfo;
		}
	}
}