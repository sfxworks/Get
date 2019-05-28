package UI 
{
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class Get extends Draggable 
	{
		private var callback:Function;
		
		public function Get(callback:Function) 
		{
			super();
			this.callback = callback;
			
			auth_btn.addEventListener(MouseEvent.CLICK, handleAuthInit);
			
		}
		
		private function handleAuthInit(e:MouseEvent):void 
		{
			notice_txt.text = "";
			
			if (endpoint_txt.text.length > 0 && username_txt.text.length > 0 && password_txt.text.length > 0 && name_txt.text.length > 0)
			{
				var authObject:Object = new Object();
				authObject.authURL = 	endpoint_txt.text;
				authObject.username = 	username_txt.text;
				authObject.password = 	password_txt.text;
				authObject.name = 		name_txt.text;
				authObject.region = 	region_txt.text;
				authObject.interfce = 	interface_txt.text;
				callback(authObject);
			}
			else
			{
				notice_txt.text = "Fill in all fields";
			}
		}
		
		public function displayError(text:String):void
		{
			notice_txt.text = text;
		}
	}

}