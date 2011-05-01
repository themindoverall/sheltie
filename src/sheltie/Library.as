package sheltie
{
	import com.rational.serialization.json.JSON;
	
	import flash.utils.ByteArray;

	public dynamic class Library
	{
		private static var _libraries:Object = {};
		public static function load(name:String):Library {
			if (_libraries[name] != null) {
				return _libraries[name];
			} else {
				var bytes:ByteArray = ResourceLoader.getInstance(name + ".json");
				var libdata:Object = JSON.decode(bytes.toString());
				var lib:Library = new Library(libdata);
				_libraries[name] = lib;
				return lib;
			}
		}
		
		public function Library(libdata:Object)
		{
			for each (var obj:Object in libdata) {
				this[obj.name] = obj;
			}
		}
	}
}