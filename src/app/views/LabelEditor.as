package app.views
{
	import flash.display.Sprite;
	
	import assets.LabelEditorUI;
	
	public class LabelEditor extends Sprite
	{
		private var ui:LabelEditorUI;
		
		public function LabelEditor()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			ui = new LabelEditorUI();
			this.addChild(ui);
		}
	}
}