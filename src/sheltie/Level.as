package sheltie
{
	import com.rational.serialization.json.JSON;
	
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	import sheltie.objects.GameObject;
	

	public class Level
	{
		public static function load(file:String):Level {
			var bytes:ByteArray = ResourceLoader.getInstance(file);
			var obj:Object = JSON.decode(bytes.toString());
			
			return new Level(obj);
		}
		
		public var map:FlxTilemap;
		
		public function Level(ldata:Object)
		{
			map = new FlxTilemap();
			
			var mapstr:String = ldata.map.replace("\\n", "\n");
			map.loadMap(mapstr, ResourceLoader.get(ldata.tileset), 16, 16, FlxTilemap.OFF,0,0,1 );			
			
			for each (var objdata:Object in ldata.objects) {
				var lib:Library = Library.load(objdata.lib);
				var libobj:Object = lib[objdata.obj];
				objdata.libobj = libobj;
				var objclass:Class = getDefinitionByName("sheltie.objects." + libobj.type) as Class;
				var obj:GameObject = new objclass(objdata);
			}
		}
	}
}