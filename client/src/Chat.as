package
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	
	import network.Client;
	import network.Method;
	import network.NetworkEvent;
	
	[Embed(source="assets/chat.swf", symbol="chat")] 
	public class Chat extends MovieClip
	{
		
		public var input:TextField;
		public var history:TextField;
		private var _enabled:Boolean = false;
		
		public function Chat()
		{
			super();
			
			input.text = '';
			input.selectable = false;
			input.type = TextFieldType.DYNAMIC;
		}
		
		public function log(msg:String, newLine:Boolean = true):void
		{
			history.appendText(msg);
			if (newLine) {
				history.appendText('\n');
			}
		}
		
		public function appendHistory(msg:String, from:Number):void
		{
			history.appendText('User' + from + ': ' + msg + '\n');
		}
		
		public function init():void
		{
			_enabled = true;
			
			input.type = TextFieldType.INPUT;
			input.selectable = true;
			input.text = 'type here';
			input.addEventListener(MouseEvent.CLICK, _onInputClick);
			input.addEventListener(KeyboardEvent.KEY_DOWN, _onInputKeyDown);
				
			Client.instance.addEventListener(Method.RECEIVE, _onReceive);
		}
		
		private function _onReceive(e:NetworkEvent):void
		{
			if (e.object.uid == Client.instance.uid) return;
			appendHistory(e.object.msg, e.object.uid);
		}
		
		private function _onInputClick(e:MouseEvent):void
		{
			if (!_enabled) return;
			if (input.text == 'type here') {
				input.text = '';
			}
		}
		
		private function _onInputKeyDown(e:KeyboardEvent):void
		{
			if (!_enabled) return;
			if (Keyboard.ENTER != e.keyCode) return;
			
			Client.instance.sendData(Method.SEND, { 
				msg: input.text
			});
			
			appendHistory(input.text, Client.instance.uid);
			input.text = '';
		}
	}
}