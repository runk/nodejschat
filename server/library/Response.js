

var common  = require("common.js");
var sys     = require("sys");

function Response(action, params) {
	this.action = action;
	this.params = params;
}

Response.prototype.action 	   	= '';
Response.prototype.params       = null;
Response.prototype.streams		= new Array();

Response.prototype.setStream	= function(stream) {
	this.streams = new Array(stream);
}

Response.prototype.setStreams 	= function(streams) {
	if (!(streams instanceof Array)) {
		throw new Error("An array of streams expecting");
	}
	this.streams = streams;
}

Response.prototype.send 		= function(streams) {
	
	if (streams != null) {
		if (streams instanceof Array) this.setStreams(streams);
		else this.setStream(streams);
	}
	
	var data = JSON.stringify({
		action: this.action,
		params: this.params
	}) + "\0";

	if (this.streams == null || this.streams.length == 0) {
		throw new Error("You have to specify stream(s) before sending any data");
	}
	
	sys.debug('Sending data (' + this.streams.length + '): ' + data);
	
	for (var s = 0; s < this.streams.length; s++) {
		if (this.streams[s].writable) {
			this.streams[s].write(data);
		} else {
			sys.debug("Encountering non-writable stream");
		}
	}

	return true;
}

module.exports = Response;
