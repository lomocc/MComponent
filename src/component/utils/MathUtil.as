package com.throne.utils
{
	import flash.geom.Point;

	public class MathUtil
	{
		/**
		 * Two times PI. 
		 */
		public static const TWO_PI:Number = 2.0 * Math.PI;
		
		/**
		 * Converts an angle in radians to an angle in degrees.
		 * 
		 * @param radians The angle to convert.
		 * 
		 * @return The converted value.
		 */
		public static function getDegreesFromRadians(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		/**
		 * Converts an angle in degrees to an angle in radians.
		 * 
		 * @param degrees The angle to convert.
		 * 
		 * @return The converted value.
		 */
		public static function getRadiansFromDegrees(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		/**
		 * Keep a number between a min and a max.
		 */
		public static function clamp(v:Number, min:Number = 0, max:Number = 1):Number
		{
			if(v < min) return min;
			if(v > max) return max;
			return v;
		}
		
		public static function range(minNum:Number, maxNum:Number, round:Boolean = true):Number
		{
			if(minNum < 0) 
			{
				var posMin:Number = (minNum*-1);
				var range:Number = posMin+maxNum;
				if(round) 
					return Math.floor(Math.random() * (range - 1))-posMin; 
				else 
					return Math.random() * (range - 1)-posMin; 
			} 
			else 
			{
				if(round)
					 return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum; 
				else
					return Math.random() * (maxNum - minNum + 1) + minNum;
			}
		}
		
		/**
		 * 零点 
		 */		
		public static const ZERO_POINT:Point = new Point(0, 0);
	}
}