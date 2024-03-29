/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	
	use namespace onyx_ns;

	public final class Halo extends Filter implements IBitmapFilter {
		
		private var __blurX:ParameterInteger;
		private var __blurY:ParameterInteger;
		private var _filter:BlurFilter					= new BlurFilter(20, 20);
		private var _bmp:BitmapData						= createDefaultBitmap();
		public var blendMode:String						= 'overlay';
		
		public function Halo():void {

			__blurX = new ParameterInteger('blurX', 'blurX', 0, 42, _filter.blurX);
			__blurY = new ParameterInteger('blurY', 'blurY', 0, 42, _filter.blurY);
			
			parameters.addParameters(
				new ParameterProxy('blur', 'blur',
					__blurX,
					__blurY
				),
				new ParameterBlendMode('blendMode', 'blendMode')
			);
		}
		
		public function applyFilter(bitmapData:BitmapData):void {

			_bmp.copyPixels(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY);
			_bmp.applyFilter(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY, _filter);
			
			bitmapData.draw(_bmp, null, null, blendMode);
		}
		
		public function terminate():void {
			_filter = null;
		}
		
		public function set blurX(x:int):void {
			_filter.blurX = __blurX.dispatch(x);
		}
		
		public function get blurX():int {
			return _filter.blurX;
		}
		
		public function set blurY(y:int):void {
			_filter.blurY = __blurY.dispatch(y);
		}
		
		public function get blurY():int {
			return _filter.blurY;
		}
		
		override public function dispose():void {
			
			if (_bmp) {
				_filter = null;
				_bmp.dispose();
				_bmp = null;
			}

		}
	}
}