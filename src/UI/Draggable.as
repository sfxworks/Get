package UI 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class Draggable extends MovieClip 
	{
		
		public function Draggable() 
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
		}
		
		private function handleMouseUp(e:MouseEvent):void 
		{
			(e.currentTarget as MovieClip).stopDrag();
		}
		
		private function handleMouseDown(e:MouseEvent):void 
		{
			(e.currentTarget as MovieClip).startDrag();
		}
		
	}

}