package network
{
    import flash.events.*;

    public class NetworkEvent extends Event 
    {
		public static const CONNECT_BEGIN:String = 'eventBeginConnect';
        public static const CONNECTED:String = 'eventConnected';
		public static const CONNECT_FAIL:String = 'eventConnectFail';
		public static const SECURITY_ERROR:String = 'eventSecurityError';
		public static const IO_ERROR:String = 'eventIoError';
		public static const CLOSED:String = 'eventClosed';
		
		private var _object:Object;

        public function NetworkEvent(type:String, object:Object=null):void
        {
            super(type);
            this._object = object;
        }

        public function get object():Object
        {
            return (this._object);
        }

        override public function clone():Event
        {
            return (new NetworkEvent(type, this._object));
        }


    }
}
