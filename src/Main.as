package
{
	import OInfraRef.AuthCredential;
	import OInfraRef.Compute;
	import UI.Get;
	import UI.Instance;
	import UI.Output;
	import events.OpenstackAuthEvent;
	import events.OpenstackComputeEvent;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.VsyncStateChangeAvailabilityEvent;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends MovieClip 
	{
		
		private static const APPLICATION_CONFIG:String = "config";
		private var addPosition:int = 0;
		
		
		//Runtime vars
		private var authCredential:AuthCredential;
		private var computeService:Compute;
		private var getView:Get;
		
		public function Main() 
		{
			
			configureDisplay();
			init();
			
		}
		
		private function init():void 
		{
			//Check for file
			
			var applicationConfigFile:File = new File(File.applicationStorageDirectory.resolvePath(APPLICATION_CONFIG).nativePath);
			if (!applicationConfigFile.exists)
			{
				getNewCredentials();
			}
			
			//If no file, 
		}
		
		private function getNewCredentials():void
		{
			getView = new Get(handleAuthObject);
			addChild_(getView);
		}
		
		private function handleAuthObject(authObject:Object):void
		{
			trace("Handling auth object");
			//Verbose visual
			var outputVisual:Output = new Output("AuthenticationService0");
			addChild_(outputVisual);
			
			//Create credential
			authCredential = new AuthCredential("AuthenticationService0", authObject.authURL, authObject.username, authObject.password, authObject.name, authObject.region, authObject.interfce);
			authCredential.attachVisual(outputVisual.displayLog);
			authCredential.addEventListener(OpenstackAuthEvent.AUTH_SUCCESS, handleAuthSuccess);
			authCredential.addEventListener(OpenstackAuthEvent.AUTH_FAILURE, handleAuthFailure);
		}
		
		private function handleAuthFailure(e:OpenstackAuthEvent):void 
		{
			getView.displayError("Authenication Failed. Check credentials.");
		}
		
		private function handleAuthSuccess(e:OpenstackAuthEvent):void 
		{
			trace("Auth Success");
			removeChild(getView);
			getView = null;
			
			//Verbose visual
			var outputVisual:Output = new Output("ComputeService0");
			addChild_(outputVisual);
			
			
			authCredential.removeEventListener(OpenstackAuthEvent.AUTH_SUCCESS, handleAuthSuccess);
			authCredential.removeEventListener(OpenstackAuthEvent.AUTH_FAILURE, handleAuthFailure);
			
			computeService = new Compute("Compute Service 0", e.token, authCredential.computeEndpoint);
			computeService.attachVisual(outputVisual.displayLog);
			computeService.addEventListener(OpenstackComputeEvent.NEW_SERVER, handleNewServer);
			
			
			
		}
		
		private function handleNewServer(e:OpenstackComputeEvent):void 
		{
			addChild_(new Instance(e.server))
		}
		
		private function addChild_(mc:MovieClip)
		{
			mc.x = mc.x + addPosition; //Lots of things need to be handled
			mc.y = mc.y + addPosition; //Including this / new objects on screen.
			
			addPosition += 10;
			
			addChild(mc);
		}
		
		
		//UI / Stage Configuration
		private function configureDisplay():void 
		{
			stage.addEventListener(VsyncStateChangeAvailabilityEvent.VSYNC_STATE_CHANGE_AVAILABILITY, handleVsync);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageWidth = stage.fullScreenWidth;
			stage.stageHeight = stage.fullScreenHeight;
			stage.nativeWindow.x = 0;
			stage.nativeWindow.y = 0;
			//stage.nativeWindow.alwaysInFront = true;
		}
		
		private function handleVsync(e:VsyncStateChangeAvailabilityEvent):void 
		{
			e.target.removeEventListener(VsyncStateChangeAvailabilityEvent, handleVsync);
			trace("Vsync Availible = " + e.available);
			if (e.available)
			{
				stage.vsyncEnabled = true;
				trace("Enabled vsync");
			}
		}
	}
	
}