package OInfraRef 
{
	import UI.Output;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author 
	 */
	public class Service extends EventDispatcher
	{
		private var logFile:File;
		
		private static const LOG_FILE:String = "log.txt";
		private var fs:FileStream;
		private var visualCallback:Function;
		internal var serviceName:String;
		
		
		public function Service() 
		{
			logFile = new File(File.applicationStorageDirectory.resolvePath(LOG_FILE).nativePath);
			fs = new FileStream();
		}
		
		public function attachVisual(callback:Function):void
		{
			visualCallback = callback;
		}
		
		public function log(str:String):void
		{
			trace(str);
			
			fs.open(logFile, FileMode.APPEND);
			fs.writeUTF(serviceName + ":" + str + "\n");
			fs.close();
			if (visualCallback != undefined) 
			{
				visualCallback(str);
			}
		}
		
	}

}