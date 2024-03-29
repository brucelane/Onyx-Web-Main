/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package ui.states {
	
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	//import flash.filesystem.*;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.*;
	import ui.text.*;
	
	use namespace onyx_ns;
	
	/**
	 * 
	 */
	public final class QuitState extends ApplicationState {
		
		/**
		 * 
		 */
		private static var startTime:int;

		/**
		 * 	@private
		 */
		private var image:DisplayObject;
		
		/**
		 * 	@private
		 */
		private var label:TextField;
		
		/**
		 * 	@private
		 */
		private var modules:Array;
	
		/**
		 * 
		 */
		override public function initialize():void {
			
			modules = [];
			
			// kill animations
			Tween.stopAllTweens();
			
			// kill states
			for each (var state:ApplicationState in StateManager._states) {
				if (state !== this) {
					StateManager.removeState(state);
				}
			}

			// kill children
			while (DISPLAY_STAGE.numChildren) {
				var ui:UIObject = DISPLAY_STAGE.removeChildAt(0) as UIObject;
				if (ui) {
					ui.dispose();
				}
			}
			
			var hasModules:Boolean;
			
			// close modules
			for each (var module:Module in PluginManager.modules) {
				hasModules = true;
				modules.push(module);
				module.addEventListener(Event.CLOSE, moduleComplete);
				module.close();
			}
			
			if (!hasModules) {
				startTime = getTimer();
				DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, frame);
			}

			// show the end screen again
			if (INITIALIZED) {
				showQuitImage();
			} else {
				quit();
			}
		}
		
		/**
		 * 	@private
		 */
		private function moduleComplete(event:Event):void {
			var module:Module = event.currentTarget as Module;
			module.removeEventListener(Event.CLOSE, moduleComplete);
			
			// kill
			modules.splice(modules.indexOf(module), 1);
			
			// quit baby
			if (modules.length === 0) {
				startTime = getTimer();
				DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, frame);
			}
		}
		
		/**
		 *	@private 
		 */
		private function frame(event:Event):void {
			if (getTimer() - startTime >= DEBUG::SPLASHTIME) {
				DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, frame);
				quit();
			}
		}
		
		/**
		 * 	@private
		 */
		private function quit(event:Event = null):void {
		}
		
		/**
		 * 	@private
		 */
		private function showQuitImage():void {
			

		}
		
		
		/**
		 * 	@private
		 * 	Traps all mouse events
		 */
		private function captureEvents(event:MouseEvent):void {
			
			event.stopPropagation();
		}

		/**
		 * 	@private
		 */
		private function onOutput(event:ConsoleEvent):void {
			label.appendText(event.message + '\n');
			label.scrollV = label.maxScrollV;
		}
	}
}