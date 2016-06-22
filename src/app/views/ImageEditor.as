package app.views
{
	import flash.display.Sprite;
	
	import assets.ImageEditorUI;

	public class ImageEditor extends Sprite
	{
		private var ui:ImageEditorUI;
		
		public function ImageEditor()
		{
			super();
			init();
		}
		
		private function init():void
		{
			ui = new ImageEditorUI();
			this.addChild(ui);
		}
	}
}