package app.utils
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	
	public class Binder
	{
		private var watchers:Array=[];
		
		public function Binder()
		{
		}
		
		public function unBinding():void
		{
			watchers.forEach(function(item:ChangeWatcher):void{
				item.unwatch();
			});
			watchers.length = 0;
		}
		
		public function bindProperty(site:Object, prop:String,
									 host:Object, chain:Object,
									 commitOnly:Boolean = false,
									 useWeakReference:Boolean = false):void
		{
			watchers.push(BindingUtils.bindProperty(site,prop,host,chain,commitOnly,useWeakReference));
		}
		
		
		public function bindSetter(setter:Function, host:Object,
								   chain:Object,
								   commitOnly:Boolean = false,
								   useWeakReference:Boolean = false):void
		{
			watchers.push(BindingUtils.bindSetter(setter,host,chain,commitOnly,useWeakReference));
		}
	}
}