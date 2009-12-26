chrome.extension.onConnect.addListener(function(port) {
  port.onMessage.addListener(function(msg) {
    var tab = port.tab;
		var actions = msg.action.split('.');
		var action  = window[actions.shift()];

		while (action && actions[0]) { action = action[actions.shift()]; }

    // if defined msg.arguments, then use it as arguments, else use msg.
    if(msg.arguments){
      var argument = (msg.arguments instanceof Array) ? msg.arguments : [msg.arguments];
    } else {
      var argument = [msg];
    }

    argument[argument.length] = tab;

		if(action instanceof Function) action.apply('', argument);
  });
})
