package tw.frost.FlashSocketIO
{
	import com.worlize.websocket.WebSocket;
	import com.worlize.websocket.WebSocketErrorEvent;
	import com.worlize.websocket.WebSocketEvent;
	import com.worlize.websocket.WebSocketMessage;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class FlashSocketIO extends EventDispatcher
	{
		
		protected var hostname:String = "localhost";
		protected var port:uint = 80;
		
		protected var socket:WebSocket = null;
		
		public function FlashSocketIO(hostname:String = "localhost", port:uint = 80)
		{
			this.hostname = hostname;
			this.port = port;
			
			var request:URLRequest = new URLRequest("http://" + this.getHostname() + "/socket.io/1/");
			var loader:URLLoader = new URLLoader(request);
			
			loader.addEventListener(Event.COMPLETE, this.onHandshakeRespond);
		}
		
		public function getHostname():String
		{
			if(port != 80) {
				return this.hostname + ":" + this.port;
			}
			return this.hostname;
		}
		
		public function connect():void
		{
			this.socket.connect();
		}
		
		private function onConnected(event:WebSocketEvent):void
		{
			this.dispatchEvent(new FlashSocketIOEvent(FlashSocketIOEvent.CONNECTED));
		}
		
		private function onClosed(event:WebSocketEvent):void
		{
			this.dispatchEvent(new FlashSocketIOEvent(FlashSocketIOEvent.CLOSED));
		}
		
		private function onMessage(event:WebSocketEvent):void
		{
			if(event.message.type == WebSocketMessage.TYPE_UTF8) {
				var rawData:String = event.message.utf8Data;
				var decodeData:Array = rawData.split(":"); // Split data by ":"
				var attachData:String = "";
				
				if(decodeData.length >= 4) { // The 4th data is attachData
					attachData = decodeData.splice(4).join(":"); // Merge into string, this data is json and ":" will be split before decode method
				}
			}
			
			if(event.message.type == WebSocketMessage.TYPE_BINARY) {
				// Drop binary data 
			}
		}
		
		private function onConnectionFailed(event:WebSocketErrorEvent):void
		{
			this.dispatchEvent(new FlashSocketIOEvent(FlashSocketIOEvent.CONNECTION_FAILED));
		}
		
		private function onAbnormalClose(event:WebSocketErrorEvent):void
		{
			this.dispatchEvent(new FlashSocketIOEvent(FlashSocketIOEvent.ABNORMAL_CLOSE));
		}
		
		private function onHandshakeRespond(event:Event):void
		{
			// Get Handshake
			var handShake:String = event.target.data;
			handShake = handShake.split(':')[0];
			
			// Create websocket connection
			this.socket = new WebSocket("ws://" + this.getHostname() + "/socket.io/1/websocket/" + handShake, "*");
			
			// Bind Events
			this.socket.addEventListener(WebSocketEvent.OPEN, this.onConnected);
			this.socket.addEventListener(WebSocketEvent.CLOSED, this.onClosed);
			this.socket.addEventListener(WebSocketEvent.MESSAGE, this.onMessage);
			this.socket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, this.onConnectionFailed);
			this.socket.addEventListener(WebSocketErrorEvent.ABNORMAL_CLOSE, this.onAbnormalClose);
		}
	}
}