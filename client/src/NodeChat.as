package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import network.Client;
	import network.Method;
	import network.NetworkEvent;
	
	[SWF(width="760", height="620", frameRate="30", backgroundColor="#FFFFFF")]
	public class NodeChat extends Sprite
	{
		
		public var chat:Chat;
		public var client:Client;
		
		public function NodeChat()
		{
			chat = new Chat();
			addChild(chat);
			
			client = new Client();
			client.addEventListener(NetworkEvent.CONNECT_BEGIN, _onConnectBegin);
			client.addEventListener(NetworkEvent.CONNECTED, _onConnected);
			client.addEventListener(NetworkEvent.CONNECT_FAIL, _onConnectFail);
			client.connect();
		}
		
		private function _onConnectBegin(e:NetworkEvent):void
		{
			chat.log('Connecting... ', false);
		}
		
		private function _onConnectFail(e:NetworkEvent):void
		{
			chat.log('failed');
		}
		
		private function _onConnected(e:NetworkEvent):void
		{
			chat.log('connected');
			chat.log('Authorizing... ', false);
			
			client.addEventListener(Method.AUTH, _onAuth);
			client.sendData(Method.AUTH);
		}
		
		private function _onAuth(e:NetworkEvent):void
		{
			chat.log('ready');
			chat.log('Your nickname is "User' + e.object.uid + '", online: ' + e.object.users);
			chat.log('');
			
			client.uid = e.object.uid;
			chat.init();
		}
		
	}
}