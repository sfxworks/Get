package 
{
	import OInfraRef.AuthCredential;
	import OInfraRef.Compute;
	import events.OpenstackAuthEvent;
	/**
	 * ...
	 * @author 
	 */
	public class Project 
	{
		private var testAuthObject:AuthCredential;
		private var testComputeObject:Compute;
		
		
		public function Project() 
		{
			trace("on");
			
			testAuthObject = new AuthCredential("https://auth.cloud.ovh.net/v3/", "FgnY6cn5S4Pg", "RrSgGJ4gXj2gXGPBPX54MHr8DGDpEx6f", "8165270612040530");
			testAuthObject.addEventListener(OpenstackAuthEvent.AUTH_SUCCESS, handleAuthSuccess);
		}
		
		private function handleAuthSuccess(e:OpenstackAuthEvent):void 
		{
			testComputeObject = new Compute(e.token, "https://compute.bhs3.cloud.ovh.net/v2.1/9152e961ece54ec6b91494ae125d037a");
		}
	
		
	}

}