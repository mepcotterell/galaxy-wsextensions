// WSEXTENSIONS
var label = $(this).parents( "div.form-row" ).find('label');
label = $(label).text().replace("\n", "").replace(/[^A-Za-z0-9]/g, "").replace("Setatruntime", "").substring(5);
		
// WSEXTENSIONS
options[ "<small>[SSE]</small> Suggest values" ] = function() {
    $.wsextensions_suggest_values(node, label);
};

// WSEXTENSIONS
options[ "<small>[SSE]</small> Documentation" ] = function() {
    $.wsxThis = label;
    $.wsextensions_show_documentation(node, label);
};


