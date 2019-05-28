package UI 
{
	import UI.Draggable;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class Output extends UI.Draggable
	{
		
		private var activeTimer:Timer;
		private var visibleTimer:Timer;
		
		public function Output(serviceName:String) 
		{
			super();
			
			name_txt.text = serviceName;
			activeTimer = new Timer(4000, 1);
			visibleTimer = new Timer(30000, 1);
			activeTimer.addEventListener(TimerEvent.TIMER, handleTimer);
			visibleTimer.addEventListener(TimerEvent.TIMER, handleTimerVisible);
		}
		
		private function handleTimerVisible(e:TimerEvent):void 
		{
			visibleTimer.stop();
			visibleTimer.reset();
			this.visible = false;
		}
		
		private function handleTimer(e:TimerEvent):void 
		{
			activeTimer.stop();
			activeTimer.reset();
			active_mc.visible = false;
		}
		
		public function displayLog(str:String):void
		{
			active_mc.visible = true;
			this.visible = true;
			activeTimer.reset();
			activeTimer.start();
			visibleTimer.reset();
			visibleTimer.start();
			
			output_txt.appendText(str + "\n");
			output_txt.scrollV = output_txt.maxScrollV;
			
		}
		
	}

}