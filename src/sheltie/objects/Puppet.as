package sheltie.objects
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxSprite;
	
	public class Puppet
	{
		public var owner:FlxSprite;
		private var animations:Object = new Object();
		public function Puppet(owner:FlxSprite, data:Object)
		{
			this.owner = owner;
			
			for (var animname:String in data["animations"]) {
				animations[animname] = _loadAnimation(animname, data["animations"][animname]);
			}
		}
		
		private function _loadAnimation(name:String, data:Object):Animation
		{
			var anim:Animation = new Animation(owner, name);
			
			for (var angle:String in data) {
				anim.addSet(parseInt(angle), data[parseInt(angle)]);
			}
			
			return anim;
		}
		
		public function play(animname:String, angle:int):void {
			owner.play(animations[animname].forAngle(angle));
		}
	}
}
import org.flixel.FlxSprite;

class Animation {
	public var sets:Array = new Array();
	public var name:String;
	public var owner:FlxSprite;
	
	public function Animation(owner:FlxSprite, name:String) {
		this.owner = owner;
		this.name = name;
	}
	
	public function addSet(angle:int, frames:Array):void {
		var setname:String = name + angle;
		this.owner.addAnimation(setname, frames, 7);
		sets.push(angle);
	}
	
	public function forAngle(angle:int):String {
		var best:int;
		var bestdiff:Number = Number.MAX_VALUE;
		for each (var setangle:int in sets) {
			var diff:int = Math.abs(setangle - angle);
			if (diff > 180) {
				diff = 360 - diff;
			}
			if (diff < bestdiff) {
				best = setangle;
				bestdiff = diff;
			}
		}
		
		return name + best;
	}
}