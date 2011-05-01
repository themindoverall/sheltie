package sheltie
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	/**
	 * The resource bundle handles automatic loading and registering of embedded resources.
	 * To use, create a descendant class and embed resources as public variables, then
	 * instantiate your class and pass it to PBE via
	 * PBE.addResources(new MyResourceBundleSubclass());. ResourceBundle will handle
	 * loading all of those resources into the ResourceManager.
	 *
	 * @see PBE.addResources PBE.addResources
	 */
	public class ResourceBundle
	{
		/**
		 * The constructor is where all of the magic happens.
		 * This is where the ResourceBundle loops through all of its public properties
		 * and registers any embedded resources with the ResourceManager.
		 */
		public var bundle:Object;
		
		public function getForName(name:String):Class
		{
			return this.bundle[name];
		}
		
		public function ResourceBundle()
		{	
			// Get information about our members (which will be embedded resources)
			var desc:XML = describeType(this);
			
			bundle = {};
			
			// Loop through each public variable in this class
			for each (var v:XML in desc.constant)
			{	
				var claz:Class = this[v.@name] as Class;
				
				bundle[String(v.@name)] = claz;
			}
		}
	}
}