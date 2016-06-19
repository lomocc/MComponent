package app.components
{
	public class ScrollBar extends TScrollBar
	{
		public function ScrollBar(ui:TScrollBarUI, orientation:String="vertical", defaultHandler:Function=null)
		{
			//TODO: implement function
			super(ui, orientation, defaultHandler);
		}
		
		override protected function createDownButton():void
		{
			_downButton = new ScrollBarUpDownButton(ui.downButton);
		}
		
		override protected function createUpButton():void
		{
			_upButton = new ScrollBarUpDownButton(ui.upButton);
			
		}		
		
	}
}