package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class OpenstackComputeEvent extends Event 
	{
		private var _server:Object;
		
		public static const NEW_SERVER:String = "newServer";
		
		public function OpenstackComputeEvent(type:String, server:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.server = server;
			
		} 
		
		public override function clone():Event 
		{ 
			return new OpenstackComputeEvent(type, _server, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("OpenstackComputeEvent", "type", "server", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get server():Object 
		{
			return _server;
		}
		
		public function set server(value:Object):void 
		{
			_server = value;
		}
		
	}
	
}