package component.buttons
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import component.buttons.TToggleButton;
	
	public class CommonToggleButton extends TToggleButton
	{
		private static const TF_LABEL:String = "tf_label";
		private static const DURATION_SHOW:Number = 0.3; //播放的时间
		private var _ui:DisplayObject;
		private var _label:String = "";
		
		protected var _onUp:MovieClip; // 按钮的正常状态
		protected var _onOver:MovieClip; // 按钮的划过状态
		
		protected var _onUpSelect:MovieClip; // 按钮的选中状态
		protected var _onOverSelect:MovieClip; // 按钮的选中的划过状态
		
		public function CommonToggleButton(ui:DisplayObject, label:String="", _defaultHandler:Function=null, params:Array=null, _select:Boolean = false,underlay:Boolean=true)
		{
			_ui = ui;
			super(ui, _defaultHandler, params,underlay);
			selected = _select;
			this.label = label;
		}
		
		override protected function initView():void
		{
			super.initView();
			
			_onUp = _ui["mc_onUp"];
			_onOver = _ui["mc_onOver"];
			_onUpSelect = _ui["mc_onUpSelect"];
			_onOverSelect = _ui["mc_onOverSelect"];
			updateState();
		}
		
		/**
		 * 设置按钮的文本 
		 * @return 
		 * 
		 */		
		public function get label():String
		{
			return this._label;
		}
		
		public function set label(value:String):void
		{
			this._label= value;
			updateLabel();
		}
		
		private function updateLabel():void
		{
			if(label == "") return;
			if(_onUp.hasOwnProperty(TF_LABEL)) _onUp[TF_LABEL].text = label;
			if(_onOver.hasOwnProperty(TF_LABEL)) _onOver[TF_LABEL].text = label;
			if(_onUpSelect.hasOwnProperty(TF_LABEL)) _onUpSelect[TF_LABEL].text = label;
			if(_onOverSelect.hasOwnProperty(TF_LABEL)) _onOverSelect[TF_LABEL].text = label;
		}
		
		override protected function updateState(event:MouseEvent=null):void
		{
			if(_selected)
			{
				onSelected();
			}else
			{
				hideSelected();
			}
			
			if(_over){
				onOver();
			}else{
				onOut();
			}
			
		}
		
		private function hideSelected():void
		{
			_onOver.visible = _onUp.visible = true;
			_onOverSelect.visible = _onUpSelect.visible = false;
		}
		
		private function onSelected():void
		{
			_onOver.visible = _onUp.visible = false;
			_onOverSelect.visible = _onUpSelect.visible = true;
		}
		
		protected function onOut():void
		{
			TweenLite.to(_onOver, DURATION_SHOW, {alpha:0});
			TweenLite.to(_onOverSelect, DURATION_SHOW, {alpha:0});
		}
		
		protected function onOver():void
		{
			TweenLite.to(_onOver, DURATION_SHOW, {alpha:1});
			TweenLite.to(_onOverSelect, DURATION_SHOW, {alpha:1});
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			_onUp = null;
			_onOver = null;
			_onUpSelect = null;
			_onOverSelect = null;
		}
		
	}
}