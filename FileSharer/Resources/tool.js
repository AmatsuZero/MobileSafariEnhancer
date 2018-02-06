var MyExtensionJavaScriptClass = function() {};

MyExtensionJavaScriptClass.prototype = {

getResource: function() {
    return window.location.href
},

run: function(arguments) {
    arguments.completionFunction({"url": document.baseURI, "resource": this.getResource() });
},

finalize: function(arguments) {
    eval(arguments["jsCode"]);
  }
};

var ExtensionPreprocessingJS = new MyExtensionJavaScriptClass;
