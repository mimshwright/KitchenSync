package org.as3lib.kitchensync.action.tween
{
	import org.as3lib.kitchensync.action.tween.*;
	
	public final class KitchenSyncObjectParser implements ITweenObjectParser {
		
		// Stores some special case keywords.
		private static var TARGET_KEYWORD:Keyword;
		private static var SCALE_KEYWORD:Keyword;
		private static var MOVE_KEYWORD:Keyword;
		private static var FILTER_KEYWORD:Keyword;
		
		private static const PROP_DELIMITER:RegExp = /\s*,\s*/;
		private static const PROP_VALUE_DELIMITER:RegExp = /\s*(=|:)\s*/;
		private static const VALUE_RANGE_DELIMITER:RegExp = /\s*[~]\s*/;
		private static const START_VALUE_MARKER:RegExp = /(_start|Start|_from|From)/;
		private static const END_VALUE_MARKER:RegExp = /(_end|End|_to|To)/;
		
		/** A collection of all keyword objects. */
		private var _keywords:Array = [];
		
		/** An array of every string defined as a keyword in a single array of strings. */
		private var _allKeywords:Array = [];
		
		/** Adds a keyword to the list of reserved words. */
		private function addKeyword(keyword:Keyword):void { 
			_keywords.push(keyword);
			_allKeywords.concat(keyword.allKeywords);
		}
		
		/** Traces a description of the keywords available. */
		public function describeKeywords():void {
			for each (var keyword:Keyword in _keywords) {
				trace(keyword.toString());
			}
		}
		
		public function KitchenSyncObjectParser() {
			addKeyword(new Keyword("duration", Object, true, "An integer or a parsable time string for the duration of the tween.", 1000, "time", "dur", "d"));
			addKeyword(new Keyword("delay", Object, true, "An integer or a parsable time string for the delay of the tween.", 0, "offset", "del"));
			addKeyword(new Keyword("easingFunction", Function, true, "The easing function for this tween." , null, "easing", "ease", "e"));
			addKeyword(new Keyword("easingMod1", Number, true, "An optional modifier for the easing function.", NaN, "mod1", "mod"));
			addKeyword(new Keyword("easingMod2", Number, true, "An optional modifier for the easing function.", NaN, "mod2"));
			addKeyword(new Keyword("autoDelete", Boolean, true, "When true, the tween will attempt to delete itself upon completion.", false));
			addKeyword(new Keyword("snapToValueOnComplete", Boolean, true, "A boolean for whether to snap to the endValue on the completion of the tween (regardless of the easingFunciton results).", true));
			addKeyword(new Keyword("description", String, true, "A description of the tween.", "Tween generated by KitchenSyncObjectParser"));
			
			// keywords ignored by automatic parsing that need special handling.
			TARGET_KEYWORD = new Keyword("target", Object, false, "A single target or an array of targets of the tween.", null, "targets", "t");
			SCALE_KEYWORD = new Keyword("scale", Number, false, "A shortcut property for scaling x and y at once.");
			FILTER_KEYWORD = new Keyword("filterType", Class, false, "A reference to the filter type whose properties you want to control with this tween. NOTE: If this is defined, all the properties will affect the filter, not the target.", null, "filter");
//			MOVE_KEYWORD = new Keyword("move", Number, false, "A shortcut property for moving x and y at once. There are three ways to use this: 1. move:'(x,y)~(x,y)', 2. moveFrom:'x,y', moveTo:'x,y', 3. moveFrom: newPoint(x,y), moveTo: new Point(x,y).", null, "position");
			
			addKeyword(TARGET_KEYWORD);
			addKeyword(SCALE_KEYWORD);
			addKeyword(FILTER_KEYWORD);
//			addKeyword(MOVE_KEYWORD);
		}
		
		private function isPropertyAKeyword(property:String):Boolean {
			if (_allKeywords.indexOf(property) >= 0) { return true; }
			return false;
		}
		
		/** 
		 * Parses a keyword, checks its value for type, and returns the result.
		 * A successfully parsed property will be removed from the list of parameters for 
		 * optimization. 
		 */
		private function parseKeyword(parameters:Object, keyword:Keyword):* {
			// for each keyword
			for each (var alias:String in keyword.allKeywords) {
				var value:* = parameters[alias] as keyword.type;
				if (value != undefined) {
					// do an explicit cast to the keyword type (to raise errors if it's wrong) and store the value. 
					if (value == null) { throw new TypeError("The value provided for " + alias + " must be of type " + keyword.type); }
					
					// delete the value from teh list of parameters so it isn't checked again.
					parameters[alias] = null;
					delete parameters[alias];
					return value;
				}
			}
			return keyword.defaultValue;
		}
		
		
		/**
		 * Automatically parses all values in the _keywords array (that are parseable).
		 */
		private function parseAllKeywords(parameters:Object, tween:KSTween):void {
			for each (var keyword:Keyword in _keywords) {
				if (keyword.includeInParsing) {
					tween[keyword.term] = parseKeyword(parameters, keyword);
				}
			}
		}
		
		/** 
		 * Returns the first defined variable within an object.
		 * Used when you need to access a value that may have multiple aliases.
		 * The values will be checked in order that they are entered.
		 * 
		 * @param object The object to check for values.
		 * @param keys The remaining parameters will be strings of property names to check in order for valid values.
		 * @return the value of the first defined property or null if all were undefined.
		 */
		private function getFirstDefinedValue(object:Object, ... keys):* {
			var key:String, value:*, i:int;
			for (i = 0; i < keys.length; i++) {
				key = keys[i];
				value = object[key] as Object;
				if (value != null && value != undefined)  {
					return value;
				}
			}
			return null;
		}
		
		public function parseObject(parameters:Object):ITween {
			// set up initial tween.
			var tween:KSTween = new KSTween([]);
			var targets:Array = parseTargets(parameters);
			
			parseAllKeywords(parameters, tween);
			
			// Check to see if the filter class is defined. 
			// if it is, all the properties will be applied to the filter.
			var filterType:Class = parseKeyword(parameters, FILTER_KEYWORD);
			
			var properties:Array = parseProperties(parameters);
			//trace("properties (" + properties.length + "):",properties);
			
			var i:int = 0, j:int = 0;
			var tl:int = targets.length, pl:int = properties.length;
			var target:Object;
			var propertyData:PropertyData;
			var tweenTarget:ITweenTarget;
			
			for (; i < tl; i += 1) {
				target = targets[i] as Object;
				
				
				for (; j < pl; j += 1) {
					propertyData = properties[j] as PropertyData;
					
					if (filterType != FILTER_KEYWORD.defaultValue) {
						tweenTarget = createFilterTargetProperty(target, filterType, propertyData);
					} else {
						tweenTarget = createTargetProperty(target, propertyData);
					}
														
					tween.addTweenTarget(tweenTarget);
				}
			} 
			return tween;
			
			function createTargetProperty(target:*, propertyData:PropertyData):ITweenTarget {
				return new TargetProperty(
					target, 
					propertyData.propertyName, 
					propertyData.startValue, propertyData.endValue
				);
			}
			
			function createFilterTargetProperty(target:*, filterType:Class, propertyData:PropertyData):ITweenTarget {
				return new FilterTargetProperty(
					target, filterType, 
					propertyData.propertyName, 
					propertyData.startValue, propertyData.endValue
				);
			}
		}
		
		/** 
		 * Parses out the targets parameter from the object.
		 */
		private function parseTargets(parameters:Object):Array {
			// extract targets
			var target:* = parseKeyword(parameters, TARGET_KEYWORD);
			if (target is Array) {
				return target;
			} if (target == null) {
				throw new SyntaxError("At least one target must be defined.");
			} else {
				return [target];
			}
		}

		
		private function parseProperties(parameters:Object):Array {
			var resultsArray:Array = new Array();
			var property:String;
			var startValue:Number;
			var endValue:Number;
			var key:String;
			
			
			for (key in parameters) {
				var data:PropertyData = new PropertyData();
				
				// check for ~ notation 
				var string:String = parameters[key].toString();				
				if (string.search("~") >= 0) {
					var values:Array = string.split("~");
					data.propertyName = key;
					data.startValue = values[0];
					data.endValue = values[1];
				} 
				

				// check for _start / _end notation.
				else {
					var startStringIndex:int = key.search(START_VALUE_MARKER);
					var endStringIndex:int = key.search(END_VALUE_MARKER);
					
					// if property name contains "_start" or "_from"
					if (startStringIndex >= 0) {
						// extract the property name
						data.propertyName = key.slice(0, startStringIndex);
						// store the start value.
						data.startValue = parameters[key] as Number;
						// extract the end value.
						data.endValue = getFirstDefinedValue(parameters, 	data.propertyName + "_end", 
																			data.propertyName + "End",
																			data.propertyName + "_to",
																			data.propertyName + "To") as Number;
						
						// if no end value was found, use the value at start of tween.
						if (isNaN(data.endValue)) {
							data.endValue = KSTween.VALUE_AT_START_OF_TWEEN;
						}
						
						// Add the property to the results list.
						resultsArray.push(data);
						continue;
					} else {
						// ignore it.
						continue;
					}
				} 
				
				// check results for keywords.
				switch (data.propertyName) {
					case "scale":
						resultsArray.push(new PropertyData("scaleX", data.startValue, data.endValue));
						resultsArray.push(new PropertyData("scaleY", data.startValue, data.endValue));
					break;

//					case "move":
//						resultsArray.push(new PropertyData("x", data.startValue, data.endValue));
//						resultsArray.push(new PropertyData("y", data.startValue, data.endValue));
//					break;
					
					default:
						// push results onto array to later be converted into tween targets.
						resultsArray.push(data);
				}
				
				// delete the parameter
				parameters[key] = null;
				delete parameters[key];
			}
			return resultsArray;
		}		
		
	}
}


import flash.utils.getQualifiedClassName;

/**
 * Represents a reserved word used in a tween object parser.
 */
internal class Keyword
{
	public function get term():String { return _term; }
	private var _term:String;
	
	public function get type():Class { return _type; }
	private var _type:Class;
	
	public function get includeInParsing():Boolean { return _includeInParsing; }
	private var _includeInParsing:Boolean;
	
	public function get description():String { return _description; }
	private var _description:String;
	
	public function get aliases():Array { return _aliases }
	private var _aliases:Array;
	
	public function get hasAliases():Boolean { return _aliases.length > 0 }
	
	public function get allKeywords():Array { return _aliases.concat(_term); }
	
	public function get defaultValue():* { return _defaultValue; }
	private var _defaultValue:*;
	
	public function Keyword(term:String, type:Class, includeInParsing:Boolean = true, description:String = "", defaultValue:* = null, ... aliases)
	{
		_term = term;
		_type = type;
		_includeInParsing = includeInParsing;
		_description = description;
		_defaultValue = defaultValue; 
		_aliases = new Array();
		
		for each (var alias:String in aliases) {
			_aliases.push(alias);
		}
	}
	
	public function toString():String {
		var string:String;
		string = term + ":" + getQualifiedClassName(type) + "\n";
		if (hasAliases) string += "\tAliases: " + allKeywords.join(', ') + "\n";
		string += "\tDefault value: " + defaultValue + "\n";
		string += "\t" + description + "\n";
		return string;
	}
}


/** 
 * Helper class for storing the start and end points of a property during the parsing of an object. 
 */
internal class PropertyData {
	public var propertyName:String;
	public var startValue:Number;
	public var endValue:Number;
	
	public function PropertyData(propertyName:String = "", startValue:Number = NaN, endValue:Number = NaN) {
		this.propertyName = propertyName;
		this.startValue = startValue;
		this.endValue = endValue;
	}
	
	public function toString():String { return propertyName + ":" + startValue + "~" + endValue }
}