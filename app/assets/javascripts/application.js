// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){
	$("#searchBox").keyup(function(){
		performSearch(this.value);
	});
});

function performSearch(text){
	if(performSearch.timeoutlId)
		clearTimeout(performSearch.timeoutlId);
	performSearch.timeoutlId = setTimeout(function(){
		console.error("performing search for", text);
		$.get("/search", {text: text}, function(response){
			console.error("received response", response);
			render(response);
		});
	}, 300);
}
performSearch.timeoutId = undefined;


function open(file, line){
	$.get("/open", {file: file, line: line}, function(){
		console.error("W00T!");
	});
}

function render(results){
	$("#results").html("");
	for (var key in results){
		$("#results").append(Mustache.render($("#code_snippet").html(), {lines: results[key], filename: key}));
	}
	prettyPrint();
	$(".openEditor").click(function(){
		open($(this).attr("filename"), $(this).attr("line_num"));
		return false;
	});
}
