package OInfraRef 
{
	import events.OpenstackAuthEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
	public class AuthCredential extends Service
	{
		
		private static const OS_TOKEN_PATH:String = "/auth/tokens";
		private static const OS_TOKEN_HEADER_NAME:String = "X-Subject-Token";
		
		private var authLoader:URLLoader;
		
		private var _authURL:String;
		private var _userDomain:String;
		private var _username:String;
		private var _password:String;
		private var _projectDomain:String;
		private var _projectName:String;
		
		private var serviceCatalog:Object;
		
		private var token:String;
		private var _region:String;
		private var _interfce:String;
		
		public function AuthCredential(serviceName:String, authURL:String, username:String, password:String, projectName:String, region:String, interfce:String, userDomain:String="Default", projectDomain:String="Default") 
		{
			this.interfce = interfce;
			this.region = region;
			this.serviceName = serviceName;
			this.projectName = projectName;
			this.projectDomain = projectDomain;
			this.password = password;
			this.username = username;
			this.userDomain = userDomain;
			this.authURL = authURL;
			
			authLoader = new URLLoader();
			authLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			authLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			authLoader.addEventListener(Event.COMPLETE, handleAuthComplete);
			authLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, handleHTTPResponseStatus);
			
			
			getToken();
		}
		
		
		
		//Primary Logic
		
		private function getToken():void
		{
			var authRequest:URLRequest = new URLRequest(authURL + OS_TOKEN_PATH);
			authRequest.contentType = "application/json";
			
			authRequest.method = URLRequestMethod.POST;
			authRequest.data = JSON.stringify(constructJsonPayload());
			authLoader.load(authRequest);
		}

		private function constructJsonPayload():Object
		{
			var payload:Object = new Object();
			payload.auth = {};
			payload.auth.identity = {};
			payload.auth.identity.methods = ["password"];
			payload.auth.identity.password = {}
			payload.auth.identity.password.user = {};
			payload.auth.identity.password.user.name = _username;
			payload.auth.identity.password.user.password = _password;
			payload.auth.identity.password.user.domain = {};
			payload.auth.identity.password.user.domain.name = _userDomain;
			payload.auth.scope = {};
			payload.auth.scope.project = {};
			payload.auth.scope.project.name = _projectName;
			payload.auth.scope.project.domain = {};
			payload.auth.scope.project.domain.name = _projectDomain;
			
			log(JSON.stringify(payload, null, 2));
			
			return payload;
			
			
		}
		
		//Event handlers
		private function handleAuthComplete(e:Event):void 
		{
			log("Complete");
			
			
			//Handle Service Catalog
			
			var returnData:Object = JSON.parse(e.target.data);
			log(JSON.stringify(returnData, null, " "))

			if (returnData.hasOwnProperty("error"))
			{
				dispatchEvent(new OpenstackAuthEvent(OpenstackAuthEvent.AUTH_FAILURE));
			}
			else
			{
				serviceCatalog = (returnData.token.catalog);
				
				dispatchEvent(new OpenstackAuthEvent(OpenstackAuthEvent.AUTH_SUCCESS, token));
			}
			
			
		}
		
		private function handleSecurityError(e:SecurityErrorEvent):void 
		{
			log("Security error");
		}
		
		private function handleIOError(e:IOErrorEvent):void 
		{
			log("IOError");
			log(e.errorID.toString());
			log(e.text);
			log(e.target.data);
		}
		
		private function handleHTTPResponseStatus(e:HTTPStatusEvent):void 
		{
			log("ResponseStatus");
			for each (var object:Object in e.responseHeaders)
			{
				log(object.name+" : " + object.value);
				if (object.name == OS_TOKEN_HEADER_NAME)
				{
					token = object.value;
					log("Token");
					log(token);
				}
			}
		}
		
		//Getter/Setters
		
		public function get authURL():String 
		{
			return _authURL;
		}
		
		public function set authURL(value:String):void 
		{
			_authURL = value;
		}
		
		public function get userDomain():String 
		{
			return _userDomain;
		}
		
		public function set userDomain(value:String):void 
		{
			_userDomain = value;
		}
		
		public function get username():String 
		{
			return _username;
		}
		
		public function set username(value:String):void 
		{
			_username = value;
		}
		
		public function get password():String 
		{
			return _password;
		}
		
		public function set password(value:String):void 
		{
			_password = value;
		}
		
		public function get projectDomain():String 
		{
			return _projectDomain;
		}
		
		public function set projectDomain(value:String):void 
		{
			_projectDomain = value;
		}
		
		public function get projectName():String 
		{
			return _projectName;
		}
		
		public function set projectName(value:String):void 
		{
			_projectName = value;
		}
		
		public function get computeEndpoint():String 
		{
			var endpointURL:String;
			for each (var service in serviceCatalog)
			{
				if (service.type == OpenstackServiceType.COMPUTE)
				{
					for each (var endpoint:Object in service.endpoints)
					{
						if (endpoint.region_id == region && endpoint["interface"] == interfce)
						{
							endpointURL = endpoint.url;
							break;
						}
					}
				}
			}
			return endpointURL;
		}
		
		public function get region():String 
		{
			return _region;
		}
		
		public function set region(value:String):void 
		{
			_region = value;
		}
		
		public function get interfce():String 
		{
			return _interfce;
		}
		
		public function set interfce(value:String):void 
		{
			_interfce = value;
		}
		
		
		
		

		
	}

}