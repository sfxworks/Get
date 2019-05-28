package OInfraRef 
{
	import events.OpenstackComputeEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author 
	 */
	public class Compute extends Service
	{
		private var authHeader:URLRequestHeader;
		private var computeLoader:URLLoader;
		private var _endpoint:String;
		
		private static const FLAVORS_ENDPOINT:String = "/flavors";
		private static const SERVERS_ENDPOINT:String = "/servers";
		private static const SERVERS_DETAIL_ENDPOINT:String = "/servers/detail";
		private static const FLAVORS_DETAIL_ENDPOINT:String = "/flavors/detail";
		private static const KEYPAIRS_ENDPOINT:String = "/os-keypairs";
		private static const LIMITS_ENDPOINT:String = "/limits";
		private static const SERVER_GROUPS_ENDPOINT:String = "/os-server-groups";
		private static const SIMPLE_TENANT_USAGE_ENDPOINT:String = "/os-simple-tenant-usage";
		
		//TODO: 
		//Guest agents?
		//Host aggregates?
		
		public function Compute(serviceName:String, token:String, endpoint:String) 
		{
			this.serviceName = serviceName;
			
			this.endpoint = endpoint;
			authHeader = new URLRequestHeader("X-Auth-Token", token);
			log("Token for COMPUTE set as " + token);
			
			getServersDetail();
		}
		
		//Application Logic TODO: Preload?
		
		/*
		public function getFlavors():void
		{
			var rq:URLRequest = new URLRequest(_endpoint + FLAVORS_ENDPOINT);
			rq.requestHeaders.push(authHeader);
			
			computeLoader.load(rq);
		}
		
		public function getServers():void
		{
			var rq:URLRequest = new URLRequest(_endpoint + SERVERS_ENDPOINT);
			rq.requestHeaders.push(authHeader);
			
			computeLoader.load(rq);
		}
		*/
		
		public function getServersDetail():void
		{
			var rq:URLRequest = new URLRequest(_endpoint + SERVERS_DETAIL_ENDPOINT);
			rq.requestHeaders.push(authHeader);
			var urlLoader:URLLoader = new URLLoader(rq);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			urlLoader.addEventListener(Event.COMPLETE, handleGetServerRequest);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
			
			log("Load server init");
			urlLoader.load(rq);
		}
		
		//Event 
		
		private function handleGetServerRequest(e:Event):void 
		{
			log(e.target.data);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			e.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			e.target.removeEventListener(Event.COMPLETE, handleRequestComplete);
			e.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
			
			
			//Handle Response
			var returnObj:Object = JSON.parse(e.target.data);
			for each (var server:Object in returnObj.servers)
			{
				log("Got Server:");
				log(JSON.stringify(server, null, "  "));
				log((server as Object).toString());
				dispatchEvent(new OpenstackComputeEvent(OpenstackComputeEvent.NEW_SERVER, server));
			}
		}
		
		private function handleRequestComplete(e:Event):void 
		{
			log("Initial Request complete");
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			e.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			e.target.removeEventListener(Event.COMPLETE, handleRequestComplete);
			e.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
		}
		
		private function handleSecurityError(e:SecurityErrorEvent):void 
		{
			log("Security Error");
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			e.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			e.target.removeEventListener(Event.COMPLETE, handleRequestComplete);
			e.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
		}
		
		private function handleIOError(e:IOErrorEvent):void 
		{
			log("IO Error");
			log(e.errorID.toString());
			log(e.text);
			log(e.target.data);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			e.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			e.target.removeEventListener(Event.COMPLETE, handleRequestComplete);
			e.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
		}
		
		private function handleHTTPStatus(e:HTTPStatusEvent):void 
		{
			log("ResponseStatus");
			for each (var object:Object in e.responseHeaders)
			{
				log(object.name+" : " + object.value);
			}
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			e.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			e.target.removeEventListener(Event.COMPLETE, handleRequestComplete);
			e.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
		}
		
		//Getter/Setter
		
		public function get token():String 
		{
			return authHeader.value;
		}
		
		public function set token(value:String):void 
		{
			authHeader = new URLRequestHeader("X-Auth-Token", token);
		}
		
		public function get endpoint():String 
		{
			return _endpoint;
		}
		
		public function set endpoint(value:String):void 
		{
			_endpoint = value;
		}
		
	}

}