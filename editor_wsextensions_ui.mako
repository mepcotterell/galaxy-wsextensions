## Web Service Extensions for the Galaxy Workflow Editor
## @author Michael Cotterell <mepcotterell@gmail.com>
## @see    LICENSE (MIT style license file).
## 
## NOTE: This file is included in editor.mako via a mako include.
##       Please see the INSTALL file for installation instructions.

## Div for suggestion engine.
## @author mepcotterell
        <div id="suggestion-engine" class="metadataForm right-content" style="display:none;">
            <div class="metadataFormTitle">Suggestion Engine</div>
            <div class="metadataFormBody">
                <div class="form-row">
                    
                    ## Predecessor
                    <label>Predecessor:</label>
                    <ul id="suggestionEnginePredecessorListItems" style="display:none;"></ul>
                    <select id="suggestionEnginePredecessorList" type="text" name="predecessor" />
                    </select>
                    <div class="toolParamHelp">The tool or operation that you want to feed into some other tool or operation.</div>
                    <br /> 

                    ## Successor
                    <label>Successor:</label>
                    <select id ="suggestionEngineSuccessorList" type="text" name="successor" />
                    </select>
                    <div class="toolParamHelp">The tool or operation that the suggestion engine needs to feed into.</div>
                    <br />                   
	                
                    ## Proposed concept
                    <label>Proposed Functionality:</label>
                    <input id="suggestionEngineDesired" type="text" name="concept" value=""/>
                    <div class="toolParamHelp">Add a concept from an ontology in order to help the suggestion engine.</div>
                    <br />

                    <!--
                    ## Type Checking
                    <label>Select Type System</label>
                    <select id="suggestionEngineTypeCheckingList" type="text" name="">
                        <option value="xsd+owl">XSD + OWL</option>
                        <option value="xsd">XSD</option>
                        <option value="owl">OWL</option>
                    </select>
                    <br />

                    ## check - contract compliance
                    <input id="suggestionEngineContractCompliance" type="checkbox" name="contractCompliance" value="true" /> Contract Compliance?
                    <br />

                    ## check - type safety
                    <input id="suggestionEngineTypeSafety" type="checkbox" name="typeSafety" value="true" /> Type Safety?
                    <br />
                    // -->

                    <br />

                    ## Run button
		            <div class='action-button' style='border:1px solid black;display:inline;' id='run-se-button'>Make Suggestions</div>
                    
                    ## this is where the results are displayed                    
                    <div id="suggestion-engine-results" style="display:none;">
                        <br />
                        <label>Ranked Results</label>
                        <div id="suggestion-engine-results-progress" style="display:none;">
                            <img src="/static/images/yui/rel_interstitial_loading.gif" />
                        </div>
                        <div id="suggestion-engine-results-content"></div>
                    </div>

                    ## this area is reserved for debug output
                    <div id="suggestion-engine-debug" style="display:none;">
                    </div>
                </div>
            </div>
        </div>
