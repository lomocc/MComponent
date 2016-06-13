package component
{
	import flash.display.MovieClip;

	public class MovieClipWrapper
	{
		private var _mc:MovieClip;
		private var _frameRate:uint;
		
		public var _totalTime:Number;
		public function MovieClipWrapper(mc:MovieClip, frameRate:uint=24)
		{
			this._mc = mc;
			this._frameRate = frameRate;
			
			this._totalTime = this._mc.totalFrames/this._frameRate;
		}
		public function get totalTime():Number
		{
			return this._totalTime;
		}
		public function get currentTime():Number
		{
			return this._mc.currentFrame/this._frameRate;
		}
		public function get movieClip():MovieClip
		{
			return this._mc;
		}
	}
}