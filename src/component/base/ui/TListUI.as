package com.throne.gui.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class TListUI extends TBaseUI
	{
		public var scrollbarUI:TScrollBarUI;
		public var masker:Sprite;
		
		public function TListUI(ui:DisplayObjectContainer=null,scrollbarUI:TScrollBarUI=null)
		{
			super(ui);
			this.scrollbarUI=scrollbarUI || new TScrollBarUI;
			masker= _mc.getChildByName("mc_masker") as Sprite || new Sprite();
		}
	}
}