
var util     		= require("util"),
	Response 		= require("Response");

function AbstractMethod() {}
//util.inherits(AbstractMethod, EventEmitter);

AbstractMethod.prototype.action  	= null;
AbstractMethod.prototype.params  	= null;
AbstractMethod.prototype.stream   	= null;
AbstractMethod.prototype.request   	= null;
AbstractMethod.prototype.response 	= new Response();

AbstractMethod.prototype.setRequest = function(request) {
	this.request = request;
	this.action  = this.request.action;
	this.params  = this.request.params;
}

AbstractMethod.prototype.setStream = function(data) {
	this.stream = data;
	this.response.setStream(this.stream);
}

AbstractMethod.prototype.error = function(msg, code, stream) {
	this.response = {
		action: error,
		params: { msg: msg, code: code }
	};
	this.reply(stream);
}

module.exports = AbstractMethod;
