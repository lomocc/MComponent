package app.components
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 *  通用按钮
	 * 
	 */
	public class CommonButton extends TButton
	{
		private static const BG_COLORS:Array = [null,0xC3C09B,0xCE6118,0x7E7E7E,0x9E9E9E];
		private static const TF_LABEL:String = "tf_label";
		private static const NORMAL:int=0;
		private static const HIGH_LIGHT:int=1;
		private static const SELECTED:int=2;
		private static const LOCKED:int=3;
		private static const LOCKEDRESERVE:int=4;
		private static const WARNING:int = 5;
		private static const DURATION_SHOW:Number = 0.3; //播放的时间
		
		private var _selected:Boolean=false; //是否是选中状态
		private var _locked:Boolean=false; // 是否是锁定状态
		private var _lockedReserve:Boolean = false; //备用的锁定状态
		private var _warning:Boolean = false; // 提示、提醒状态
		
		private var _ui:DisplayObject;
		private var _bg:MovieClip; // 按钮的背景
		private var _onUp:MovieClip; // 按钮的正常状态
		private var _onOver:MovieClip; // 按钮的划过状态
		private var _onSelected:MovieClip; // 按钮的选中状态
		private var _onLocked:MovieClip; // 按钮的锁定状态
		private var _onLockedReserve:MovieClip; // 按钮的备用锁定状态
		private var _onWarning:MovieClip;
		
		private var _label:String = "";
		private var _status:int = -1;
		
		public function CommonButton(ui:DisplayObject, label:String="", _defaultHandler:Function=null, params:Array=null, _select:Boolean = false, _lock:Boolean = false, underlay:Boolean=true)
		{
			_ui = ui;
			
			selected = _select;
			locked = _lock;
			super(ui, _defaultHandler, params, underlay);
			this.label = label;
		}
		
		override protected function initView():void
		{
			super.initView();
			
			_onUp = _ui["mc_onUp"];
			_onOver = _ui["mc_onOver"];
			if(_ui.hasOwnProperty("mc_onSelected")) _onSelected = _ui["mc_onSelected"];
			if(_ui.hasOwnProperty("mc_onLocked")) _onLocked = _ui["mc_onLocked"];
			if(_ui.hasOwnProperty("mc_onLockedReserve")) _onLockedReserve = _ui["mc_onLockedReserve"];
			if(_ui.hasOwnProperty("mc_onWarning")) _onWarning = _ui["mc_onWarning"];
			if(_ui.hasOwnProperty("mc_bg")) _bg = _ui["mc_bg"];
			
			updateState();
		}
		
		override protected function defaultHandler(event:MouseEvent):void
		{
			if(selected || locked || lockedReserve) return;
			super.defaultHandler(event);
		}
		
		
		override protected function updateState(event:MouseEvent=null):void
		{
			buttonMode = !_locked && !selected && !_lockedReserve && (_enable || _warning);
			
			if(selected)//选中状态
			{
				status = SELECTED;
				return;
			}
			if(locked) //锁定状态
			{
				status = LOCKED;
				return;
			}
			if(lockedReserve) //备用锁定状态
			{
				status = LOCKEDRESERVE;
				return;
			}
			if(_over)
			{
				status = HIGH_LIGHT;
			}
			else if(warning) // 提醒、提示状态
			{
				status = WARNING;
			}
			else
			{
				status = NORMAL;
			}
		}
		
		public function get status():int
		{
			return _status;
		}
		
		public function set status(value:int):void
		{
			if(_bg) TweenLite.to(_bg,0.3,{tint:BG_COLORS[status]});
			
			if(_status == value) return;
			_status = value;
			onStatus();
		}
		
		/**
		 *  提示、提醒状态 
		 * @return 
		 * 
		 */		
		public function get warning():Boolean
		{
			return _warning;
		}
		
		public function set warning(value:Boolean):void
		{
			if(_warning == value) return;
			_warning = value;
			if(_warning)
			{
				_selected = false;
				_locked = false;
				_lockedReserve = false;
			}
			updateState();
		}
		
		/**
		 * 选择状态 
		 * @return 
		 * 
		 */		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected)
			{
				_locked = false;
				_lockedReserve = false;
				_warning = false;
			}
			updateState();
		}
		
		/**
		 * 锁定状态 
		 * @return 
		 * 
		 */		
		public function get locked():Boolean
		{
			return _locked;
		}
		
		public function set locked(value:Boolean):void
		{
			if(_locked == value) return;
			_locked = value;
			if(_locked) 
			{
				_selected = false;
				_lockedReserve = false;
				_warning = false;
			}
			updateState();
		}
		
		/**
		 * 备用的锁定状态 
		 * @return 
		 * 
		 */		
		public function get lockedReserve():Boolean
		{
			return _lockedReserve;
		}
		
		public function set lockedReserve(value:Boolean):void
		{
			if(_lockedReserve == value) return;
			_lockedReserve = value;
			if(_lockedReserve)
			{
				_selected = false;
				_locked = false;
				_warning = false;
			}
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
		
		/**
		 * 去除所有的状态 
		 * 
		 */		
		public function removeAllStatus():void
		{
			_selected = false;
			_locked = false;
			_lockedReserve = false;
			_warning = false;
			updateState();
		}
		
		private function updateLabel():void
		{
			if(label == "") return;
			if(_onUp.hasOwnProperty(TF_LABEL)) _onUp[TF_LABEL].text = label;
			if(_onOver.hasOwnProperty(TF_LABEL)) _onOver[TF_LABEL].text = label;
			if(_onSelected && _onSelected.hasOwnProperty(TF_LABEL)) _onSelected[TF_LABEL].text = label;
			if(_onLocked && _onLocked.hasOwnProperty(TF_LABEL)) _onLocked[TF_LABEL].text = label;
			if(_onLockedReserve && _onLockedReserve.hasOwnProperty(TF_LABEL)) _onLockedReserve[TF_LABEL].text = label;
			if(_onWarning && _onWarning.hasOwnProperty(TF_LABEL)) _onWarning[TF_LABEL].text = label;
		}
		
		private function onStatus():void
		{
			if(!_onUp || !_onOver) return;
//			TweenLite.to(_onUp, DURATION_SHOW, {autoAlpha:0});
			TweenLite.to(_onOver, DURATION_SHOW, {autoAlpha:0});
			if(_onSelected) TweenLite.to(_onSelected, DURATION_SHOW, {autoAlpha:0});
			if(_onLocked) TweenLite.to(_onLocked, DURATION_SHOW, {autoAlpha:0});
			if(_onLockedReserve) TweenLite.to(_onLockedReserve, DURATION_SHOW, {autoAlpha:0});
			if(_onWarning) TweenLite.to(_onWarning, DURATION_SHOW, {autoAlpha:0});
			switch(status)
			{
				case HIGH_LIGHT :
					TweenLite.to(_onOver, DURATION_SHOW, {autoAlpha:1});
					break;
				
				case SELECTED :
					if(_onSelected) TweenLite.to(_onSelected, DURATION_SHOW, {autoAlpha:1});
					break;
				
				case LOCKED :
					if(_onLocked) TweenLite.to(_onLocked, DURATION_SHOW, {autoAlpha:1});
					break;
				
				case LOCKEDRESERVE :
					if(_onLockedReserve) TweenLite.to(_onLockedReserve, DURATION_SHOW, {autoAlpha:1});
					break;
				
				case WARNING:
					if(_onWarning) TweenLite.to(_onWarning, DURATION_SHOW, {autoAlpha:1});				
					break;
				
				default :
//					TweenLite.to(_onUp, DURATION_SHOW, {autoAlpha:1});
					break;
			}
		}
		
		override protected function playPressSound():void
		{
//			GlobalValue.soundManager.playSfx(SoundConfigUtil.getUISfxURL(UISfxs.BUTTON_PRESS));
		}
		
		override public function dispose():void
		{
			super.dispose();
			_ui = null;
			_bg = null;
			_label = null;
			_onUp = null;
			_onOver = null;
			_onLocked = null;
			_onSelected = null;
			_onLockedReserve = null;
			_onWarning = null;
		}
		
	}
}