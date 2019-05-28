package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class OpenstackAuthEvent extends Event 
	{
		private var _token:String;
		
		public static const AUTH_SUCCESS:String = "authsuccess";
		public static const AUTH_FAILURE:String = "authfailure";
		
		public function OpenstackAuthEvent(type:String, token:String=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.token = token;
		} 
		
		public override function clone():Event 
		{ 
			return new OpenstackAuthEvent(type, token, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("OpenstackAuthEvent", "type", "token", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get token():String 
		{
			return _token;
		}
		
		public function set token(value:String):void 
		{
			_token = value;
		}
		
	}
	
}