package network
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	
	import network.NetworkEvent;

	public class Client extends EventDispatcher
	{
		private var _xmlSocket:XMLSocket;
		public static var instance:Client;
		
		public static const PORT:Number = 7001;
		public static const HOST:String = 'localhost';
		public var uid:Number = -1;
		
		public function Client()
		{
			_xmlSocket = new XMLSocket();
			instance = this;
		}
		
		public function connect():void
		{
			dispatchEvent(new NetworkEvent(NetworkEvent.CONNECT_BEGIN));
			
			_xmlSocket.connect(HOST, PORT);
			_xmlSocket.addEventListener(Event.CONNECT, _onConnected);
			_xmlSocket.addEventListener(Event.CLOSE, _onClosed);
			_xmlSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
			_xmlSocket.addEventListener(IOErrorEvent.IO_ERROR, _onIoError);
			_xmlSocket.addEventListener(DataEvent.DATA, _onIncomingData);
		}
		
		public function sendData(method:String, params:Object = null):void
		{
			if (params == null) params = new Object();
			params.uid = this.uid;
			
 			var request:String = JSON.encode({
				action: method, 
				params: params
			});
			_xmlSocket.send(request);
		}
		
		public function disconnectHandler(event:MouseEvent):void
		{
			_xmlSocket.close();
		}
		
		private function _onConnected(e:Event):void
		{
			dispatchEvent(new NetworkEvent(NetworkEvent.CONNECTED));
		}
		
		private function _onClosed(e:Event):void
		{
			dispatchEvent(new NetworkEvent(NetworkEvent.CLOSED));
		}
		
		private function _onIoError(e:IOErrorEvent):void
		{
			dispatchEvent(new NetworkEvent(NetworkEvent.CONNECT_FAIL));
			dispatchEvent(new NetworkEvent(NetworkEvent.IO_ERROR));
		}
		
		private function _onSecurityError(e:SecurityErrorEvent):void
		{
			dispatchEvent(new NetworkEvent(NetworkEvent.CONNECT_FAIL));
			dispatchEvent(new NetworkEvent(NetworkEvent.SECURITY_ERROR));
		}
		
		public function _onIncomingData(event:DataEvent):void
		{
			trace("[" + event.type + "] " + event.data);
			
			if (event.data.indexOf('<?xml version="1.0"?>') == 0) {
				return;
			}
			
			var o:Object = JSON.decode(event.data);
			dispatchEvent(new NetworkEvent(o.action, o.params));
		}
	}
}