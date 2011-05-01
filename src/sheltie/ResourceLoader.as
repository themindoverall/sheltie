package sheltie
{
	import flash.utils.describeType;
	
	import sheltie.Resources;
	
	public class ResourceLoader
	{
		private static var res:Resources = new Resources();
		public static function get(filename:String):Class
		{
			var gname:String = filename.replace('.', '_');
			return res.bundle[gname];
		}
		
		public static function getInstance(filename:String):*
		{
			return new (get(filename))();
		}
	}
}