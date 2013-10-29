package tw.frost.FlashSocketIO
{
	import flash.events.Event;
	
	public class FlashSocketIOEvent extends Event
	{
		public static const CONNECTED:String = "connected";
		public static const CLOSED:String = "closed";
		public static const MESSAGE:String = "message";
		public static const CONNECTION_FAILED:String = "connection_failed";
		public static const ABNORMAL_CLOSE:String = "abnormal_close";
		
		public function FlashSocketIOEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}