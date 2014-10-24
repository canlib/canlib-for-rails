// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery_ujs
//= require_tree .

$(function() {

	$("li[name='book_kept']").bind("taphold", function(){
		$.mobile.changePage("#popup_kept", {transition: "pop", role: "dialog"});
	});

	$("li[name='book_rented_out']").bind("taphold", function(){
		$.mobile.changePage("#popup_rented_out", {transition: "pop", role: "dialog"});
	});

	$("li").bind("tap", function(){
		$.mobile.changePage("#show_detail");
	});

	$("#add_book_btn").click(function() {
		$("#book_title").val("");
		$("#book_author_name").val("");
	});

});

