
Policy = {
	isPolicyRequest: function(data) {
		return (data == '<policy-file-request/>\0');
	},
	sendPolicy: function(stream) {
		stream.write('<?xml version="1.0"?>\n<!DOCTYPE cross-domain-policy SYSTEM'
	          + ' "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">\n'
			  + '<cross-domain-policy>\n'
	  		  + '<allow-access-from domain="*" to-ports="*"/>\n'
	  		  + '</cross-domain-policy>\n\0');
	}
}

module.exports = Policy;
