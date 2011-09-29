
var AbstractMethod 	= require("AbstractMethod.js");
var common 			= require("common.js");
var util     		= require("util");

function Send() {}
util.inherits(Send, AbstractMethod);

Send.prototype.exec = function() {
	this.response.action = 'Receive';
	this.response.params = this.params;
	this.response.send(common.streams);
}

module.exports = new Send();
