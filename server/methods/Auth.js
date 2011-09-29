

var AbstractMethod 	= require("AbstractMethod.js");
var common 			= require("common.js");
var util     		= require("util");

function Auth() {}

util.inherits(Auth, AbstractMethod);

Auth.prototype.exec = function() {
    this.response.action = this.action;
    this.response.params = { 
		uid: 	common.lastUserId++,
		users: 	common.streams.length
	};
    this.response.send(this.stream);
}

module.exports = new Auth();
