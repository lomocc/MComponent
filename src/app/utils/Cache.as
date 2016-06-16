package app.utils
{
	import flash.utils.Dictionary;
	
	public class Cache
	{
		public function Cache()
		{
		}
		static private var contentCache:Dictionary;
		static public function get(name:String):*
		{
			if(!contentCache)
				return null;
			return contentCache[name];
		}
		static public function put(name:String, content:*):void
		{
			if(!contentCache)
				contentCache = new Dictionary();
			contentCache[name] = content;
		}
		static public function remove(name:String):void
		{
			if(!contentCache)
				return;
			if(name != null)
				delete contentCache[name];
			else
				contentCache = null;
		}
	}
}