
## Web Service Extensions for the Galaxy Workflow Editor
## @author Michael Cotterell <mepcotterell@gmail.com>
## @see    LICENSE (MIT style license file).
## 
## NOTE: This file is included in editor.mako via a mako include.
##       Please see the INSTALL file for installation instructions.

## The product version
WSEXTENSIONS_VERSIONS = "1.2";

## The JSONP URI endpoint for the Suggestion Engine Web Service
## @author Michael Cotterell <mepcotterell@gmail.com>
WSEXTENSIONS_SE_SERVICE_URI = "http://localhost:8084/SuggestionEngineWS/jsonp";

## A global array of messages that we can access from the JavaScript console.
## @author Michael Cotterell <mepcotterell@gmail.com>
WSEXTENSIONS_LOG = [];

## This function logs a message to the global log array.
## @author Michael Cotterell <mepcotterell@gmail.com>
function wsextensions_log(message) {
    var msg = "LOG [" + (new Date()) + "] " + arguments.callee.caller.name + " : " + message;
    WSEXTENSIONS_LOG.push(msg);
}

## This function logs an error to the global log array.
## @author Michael Cotterell <mepcotterell@gmail.com>
function wsextensions_error(message) {
    var caller = "SERVER SIDE";
    if (arguments.callee.caller != null) {
        var caller = arguments.callee.caller.name;
    }
    var msg = "ERROR [" + (new Date()) + "] " + caller + " : " + message;
    show_modal( "Web Service Extensions Error", msg, { "Ignore error" : hide_modal } );
    WSEXTENSIONS_LOG.push(msg);
}

## Show the log
## @author Michael Cotterell <mepcotterell@gmail.com>
function wsextensions_show_log() {
    var n = WSEXTENSIONS_LOG.length;
    var out = '<textarea rows="10" cols="160">';
    for (var i = 0, len = n; i < len; ++i) {
        out += WSEXTENSIONS_LOG[i] + '\n\n';
    }
    out += '</textarea>';
    show_modal( "Web Service Extensions Log", out, { "Close" : hide_modal } );
}

## Show the about dialog
## @author Michael Cotterell <mepcotterell@gmail.com>
function wsextensions_show_about() {
    var msg = "<strong>Product Version:</strong> wsextensions v" + WSEXTENSIONS_VERSIONS + "<br />";
    msg += "<br />";
    msg += 'Web Service Extensions for Galaxy are based on software from the'  + "<br />";
    msg += 'University of Georgia Web Services Annotations Group, which has' + "<br />";
    msg += 'been licensed under the [insert license information here].' + "<br />";
    msg += "<br />";
    msg += 'For more information, please visit ' + "<br />";
    msg += '<a href="http://mango.ctegd.uga.edu/jkissingLab/SWS/Wsannotation/">http://mango.ctegd.uga.edu/jkissingLab/SWS/Wsannotation/</a>.' + "<br />";
    msg += "<br />";
    msg += 'User interface for this tool implemented by ' + "<br />";
    msg += '<a href="http://michaelcotterell.com/">Michael E. Cotterell</a>.' + "<br />";
    show_modal( "About Web Service Extensions", msg, { "Close" : hide_modal } );
}

## The folowing assignments make the logging functions available globally.
## @author Michael Cotterell <mepcotterell@gmail.com>
$.wsextensions_log      = wsextensions_log;
$.wsextensions_error    = wsextensions_error;
$.wsextensions_show_log = wsextensions_show_log;

## Add the dropdown menu for WS Extensions
## @author Michael Cotterell <mepcotterell@gmail.com>
$("#workflow-options-button").replaceWith('<a id="workflow-suggestions-button" class="panel-header-button popup" href="#">Web Service Extensions</a> <a id="workflow-options-button" class="panel-header-button popup" href="#">Options</a>');

## Add the suggestion engine popup menu to the Galaxy worflow editor.
## @author Michael Cotterell <mepcotterell@gmail.com>
make_popupmenu( $("#workflow-suggestions-button"), {
    "Suggestion Engine": wsextensions_make_se_panel,
    "About": wsextensions_show_about,
    "View Debug Log" : wsextensions_show_log
});

## Sets up the right panel in the workflow editor for use with the Suggestion
## Engine. This gets run when the suggestion engine popup menu button is 
## clicked.
## @author Michael Cotterell <mepcotterell@gmail.com>
function wsextensions_make_se_panel() {

    ## Log it
    wsextensions_log("Preparing the right panel for the Suggestion Engine interface.");    
        
    ## deselect the active node in the workflow, if any.
    workflow.clear_active_node();
            
    ## clear the right panel            
    $('.right-content').hide();

    ## the predecessor and successor selection boxes
    $('#suggestionEnginePredecessorList').empty();
    $('#suggestionEngineSuccessorList').empty();

    ## provide options to choose none
    $('#suggestionEnginePredecessorList').append($('<option></option>').val('none').html('--all--'));
    $('#suggestionEngineSuccessorList').append($('<option></option>').val('none').html('--all--'));

    ## fill the predecessor and successor selection boxes            
    for (var node_key in workflow.nodes) {
                
        ## get the current node in the iteration                
        var node = workflow.nodes[node_key];

        ## if the node is a tool, add it to the lists
        if(node.type == 'tool') {
            $('#suggestionEnginePredecessorList').append($('<option></option>').val(node.name).html("Step " + node.id + " - " + node.name));
            $('#suggestionEngineSuccessorList').append($('<option></option>').val(node.name).html("Step " + node.id + " - " + node.name));
        } // if

    } // for           

    ## Log it
    wsextensions_log("Rendering the Suggestion Engine interface in the right panel.");  

    ## show the suggestion engine div
	$('#suggestion-engine').show();

    ## register the click event for the run button            
    $("#run-se-button").click(wsextensions_se_request);

} // function wsextensions_make_se_panel()     

## Sends the information to the Suggestion Engine Web Service, parses
## the results, and renders them to the page.
## @author Michael Cotterell <mepcotterell@gmail.com>
function wsextensions_se_request() {

    ## register the click event for the run button            
    $("#run-se-button").click(wsextensions_se_request);

    ## Unhide the results section
    $("#suggestion-engine-results").show();

    ## Display the progress bar.
    $("#suggestion-engine-results-progress").show();

    ## Log it
    wsextensions_log("Preparing to make a request to the Suggestion Engine Web Service.");

    ## This a simple WebServiceTool python class that we use instead of Galaxy's
    ## built-in Tool class. We do this because there seems to be, at the time of
    ## this writing, a bug in the way the tool XML files are parsed which
    ## prevents us from properly accessing a tool's input parameters.
    ##
    ## @see https://bitbucket.org/galaxy/galaxy-central/issue/589/tool-class-not-parsing-input-parameters
    ## @TODO finish documenting the python code in this snippet
    <%
        import xml.dom.minidom

        """Simple class for parsing Web Service Tool XML files."""
        class WebServiceTool:
    
            def __init__(self, config_file):
                self.config_file = config_file
                self.dom = xml.dom.minidom.parse(self.config_file)
                self.inputs = {}
                self.handleToolInputs(self.dom.getElementsByTagName("inputs")[0])

            def handleToolInputs(self, inputs):
                self.handleInputParams(inputs.getElementsByTagName("param"))

            def handleInputParams(self, params):
                for param in params:
                    self.handleInputParam(param)

            def handleInputParam(self, param):
                name = param.getAttribute('name')
                value = param.getAttribute('value')
                self.inputs[name] = value
    %>

    ## STEP 1 - Gather all the information we can about the Web Service Tools
    ##          that are both available to the current user and workflow
    ##          compliant.
    wsextensions_log("Gathering candidate operations.");

    ## The name of the Tool sections where the Web Service Tools are located.
    ## @TODO make this an array, just in case.
    var candidateOpsSections = "Select Web Service Workflow Tool";

    ## This array will hold the candidate operations.
    ## They contents of this array should each be in the form of 
    ##   <operation>@<wsdl>
    ## or
    ##   <operation>@<wsdl>@<toolid>
    ## Including the Tool ID will make it possible add a candidate operation
    ## into the workflow directly from the result list.
    var candidateOps = [];

    ## Iterate over all the Tools in the Tool Panel
    %for section_key, section in app.toolbox.tool_panel.items():

        ## Only consider the sections containing Web Service Tools
        if ("${section.name}" == candidateOpsSections) {
                
            ## Iterate over the Tools in the current section that are both
            ## workflow compatible and not hidden.
            %for tool_key, tool in section.elems.items():
                %if tool_key.startswith( 'tool' ):
                    %if not tool.hidden:
                        %if tool.is_workflow_compatible:

                            ## Parse the Web Service Tool and extract the
                            ## parameters that we need.
                            <%
                                wstool = WebServiceTool(tool.config_file)
                                wsurl = "%s" % wstool.inputs.get("url", "")
                                wsop = "%s" % wstool.inputs.get("method", "")
                                wsst = "%s" % wstool.inputs.get("servicetype", "")
                                wstoolid = tool.id
                            %>

                            ## Push this Tool into our array
                            candidateOps.push(["${wsop}@${wsurl}@${wstoolid}"]);

                        %endif
                    %endif
                %endif
            %endfor

        } // if

    %endfor

    ## Did we find any candidate operations? If not, let us register an error.
    if (candidateOps.length == 0) {
        wsextensions_error("Could not find any candidate operations.");
    } // if

    ## STEP 2 - Gather information about the current state of the workflow. 
    ##
    ##          @FIXME The current implementation does not distinguish between
    ##                 regular Tools and Web Services. For now, we assume that
    ##                 the workflow is only composed of Web Service Tools. This
    ##                 obviously needs to be fixed before release. 
    wsextensions_log("Gathering current workflow operations.");

    ## This array will hold the workflow operations.
    ## They contents of this array should each be in the form of 
    ##   <operation>@<wsdl>
    ## or
    ##   <operation>@<wsdl>@<toolid>
    ## Including the Tool ID here is not really needed. However, I chose to
    ## provide this option so that it is consistent with the candidateOps array.
    var workflowOps = [];      

    ## Iterate over the nodes in the current workflow.
    for (var node_key in workflow.nodes) {
    
        ## This is the current node.        
        var node = workflow.nodes[node_key];

        ## Consider only nodes that are Tools.
        ## @FIXME need to only consider Web Service Tools
        if(node.type == 'tool') {

            ## Get the operation name.
            ## Web Service Tool nodes have names in the form 
            ## of <service>.<operation>
            var wsop = node.name.split(".")[1];

            ## Get the operation's WSDL URL
            ## @EPIC Uses sexy jQuery magic.
            var wsurl = $('input[name="url"]', $(node.form_html)).attr('value');

            ## Get the Web Service Tool's tool_id
            var wstoolid = node.tool_id;

            ## Push it into our array
            workflowOps.push([wsop + "@" + wsurl + "@" + wstoolid]);

        }
    }

    ## Did we find any operations in the current workflow? If not, let us
    ## register an error.
    if (workflowOps.length == 0) {
        wsextensions_error("Could not find any operations in the current workflow.");
    } // if

    ## STEP 3 - Gather all the other information from the form
    wsextensions_log("Gathering information from the form in the Suggestion Engine interface.");

    ## The desired functionality. Either some string similar to an operation
    ## or a URI to some concept in an ontology.
    var desiredFunctionality = $('#suggestionEngineDesired').attr('value');

    ## A set of type checking constraints.
    var typeChecking = $('#suggestionEngineTypeCheckingList').attr('value');

    ## A boolean value (sent as a string) indicating whether or not to
    ## enforce contract compliance.
    var contractCompliance = $('#suggestionEngineContractCompliance').attr('checked');
    if (contractCompliance != null) {
        contractCompliance = contractCompliance.toString();
    }

    ## A boolean value (sent as a string) indicating whether or not to
    ## enforce type safety.
    var typeSafety = $('#suggestionEngineTypeSafety').attr('checked');
    if (typeSafety != null) {
        typeSafety = typeSafety.toString();
    }

    ## STEP 4 - Submit the request to the Suggestion Engine Web Service
    wsextensions_log("Submitting the request to the Suggestion Engine Web Service via JSONP.");

    var request = WSEXTENSIONS_SE_SERVICE_URI
        + "?operation="            + "getSuggestions"
        + "&workflowOps="          + workflowOps 
        + "&candidateOps="         + candidateOps
        + "&desired="              + desiredFunctionality 
        + "&typeChecking="         + typeChecking
        + "&contractCompliance="   + contractCompliance
        + "&typeSafety="           + typeSafety

    ## make a JSON request
    $.getJSON(request + "&jsonp_callback=?", wsextensions_se_parse_response);

    ## don't really need this return but it's recommended for some reason
    return false;

} // function wsextensions_se_request

## Parses the response from the Suggestion Engine Web Service and renders the
## results to the Suggestion Engine interface within the workflow editor. This
## function is only called if the jQuery JSON request was successful.
## @author Michael Cotterell <mepcotterell@gmail.com>
function wsextensions_se_parse_response(suggestions) {            
            
    ## Log it
    wsextensions_log("Processing the response from the Suggestion Engine Web Service");

    ## The number of suggestions returned.
    var n = suggestions.length;

    ## If there were no suggestions returned then raise an error.
    if (n == 0) {
        wsextensions_error("Received a response from the Suggestion Engine Web Service, but it did not contain any results");
        ## @TODO handle this more gracefully
    } // if    
    
    ## prepare output list
    var out = "<ol>";

    ## loop over suggestions
    for (var i = 0, len = n; i < len; ++i) {

        ## Each suggestion is an array of the following:
        ## 0: Operation Name
        ## 1: WSDL URL
        ## 2: Rank Score
        ## 3: Unweighted Data Mediation Sub-score
        ## 4: Unweighted Functionality Sub-score
        ## 5: Unweighted Preconditions / Effects Sub-score
        ## 6: Galaxy tool_id

        ## The operation name.         
        var op = suggestions[i][0];

        ## The operation's WSDL URL.
        var wsdl = suggestions[i][1];

        ## The operation's rank score.
        var rank = suggestions[i][2];

        ## The operation's data mediation sub-score.
        var dm = suggestions[i][3];

        ## The operation's functionality sub-score.
        var fn = suggestions[i][4];

        ## The operation's preconditons/effects sub-score.
        var pe = suggestions[i][5];

        ## The short name of the wsdl, derived from the WSDL URL
        var short_wsdl = wsdl.substring(wsdl.lastIndexOf('/') + 1);

        ## The web service name, derived from the short wsdl name
        var service = short_wsdl.substring(0, short_wsdl.lastIndexOf('.'));

        ## The link which allows one to add the operation to the current workflow
        var add_link = '';

        wsextensions_log("Parsing suggestion for " + service + "." + op + " --> extra_info = " + suggestions[i][6]);

        ## Check to see if a galaxy tool_id was received. If so, this implies that
        ## the user has the tool already available to them in the workflow editor.
        if (suggestions[i][6] != null) {

            ## The galaxy tool id
            var tool_id = suggestions[i][6];

            ## Generate the add link
            add_link = '<small>Installed: <a href="#" onclick="add_node_for_tool( \'' + tool_id + '\', \'' + service + '.' + op + '\' )">add to workflow</a></small>';

        } else {

            ## Otherwise, let them know that they add this tool using Radiant Web.
            add_link = '<small>Available: RadiantWeb!</small>';

        }

        ## Prepare the result for rendering
        out += "<li>";
        out += op + "<br />";
        out += "<a href=\"" + wsdl + "\" style=\"color:#FF66FF;\"><span style=\"color:#FF66FF;\"><small>" + short_wsdl + "</small></span></a>" + "<br />";
        out += "<span style=\"color:#999999;\"><small>" + rank + " (DM: " + dm + ", FN: " + fn + ")</small></span>" + "<br />";
        out += add_link + "<br />";
        out += "<br />";
        out += "</li>";
        
    } // for

    ## finish the output list
    out += "</ol>";

    ## Log it
    wsextensions_log("Response parsed, rendering results to the Suggestion Engine interface.");

    ## Hide the progress bar.
    $("#suggestion-engine-results-progress").hide();

    ## display the results
    $("#suggestion-engine-results-content").replaceWith('<div id="suggestion-engine-results-content">' + out + '</div>');

} // function wsextensions_se_parse_response
