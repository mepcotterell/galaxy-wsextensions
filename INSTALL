INSTALL

Web Service Extensions for the Galaxy Workflow Editor

@author Michael Cotterell <mepcotterell@gmail.com>
@see    LICENSE (MIT style license file).

1. Merge the templates directory into your galaxy distribution.

2. Make the following chages to your templates/workflow/editor.mako file:

   a. Find:

        // jQuery onReady
        $( function() {

      and replace with:

        // jQuery onReady
        $( function() {

	    ## Include Galaxy Web Service Extensions Logic File.
            <%include file="editor_wsextensions.mako"/>

   b. Find:

        ## Div where tool details are loaded and modified.
        <div id="right-content" class="right-content"></div>

      and replace with:

        ## Include the Galaxy Web Service Extensions UI file.
        <%include file="editor_wsextensions_ui.mako"/>

        ## Div where tool details are loaded and modified.
        <div id="right-content" class="right-content"></div>

   c. Find:

	var b = $('<a class="popup-arrow" id="popup-arrow-for-' + id + '">&#9660;</a>');
        var options = {};

      and replace with:

	var b = $('<a class="popup-arrow" id="popup-arrow-for-' + id + '">&#9660;</a>');
        var options = {};

	## Include the worflow editor Web Service extensions for input values.
	## @author Michael Cotterell <mepcotterell@gmail.com>
        <%include file="editor_wsextensions_param.mako"/>

   c. That's it!

