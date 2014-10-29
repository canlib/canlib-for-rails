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

	$("#add_book_btn").bind("tap", function(){
		$("#book_title").val("");
		$("#book_author_name").val("");
	});

	$("#update_submit_btn").bind("tap", function(){
		$("form.edit_book").submit();
	});

	$("#edited_title").keyup(function(){
		if ($.trim($("#edited_title").val()).length == 0 || $.trim($("#edited_author").val()).length == 0) {
			$("#update_dialog_btn").addClass("ui-disabled");
		} else {
			$("#update_dialog_btn").removeClass("ui-disabled");
		}
	});

	if ($("#search").val().length > 0) {
		$("#search_button").removeClass("ui-disabled");
		$("#search_button").removeAttr("disabled");
	}

	$("a[title='Clear text']").bind("tap", function(){
		$("#search_button").addClass("ui-disabled");
	});	
		
	$("#search").keyup(function(){
			if ($("#search").val().length == 0) {
				$("#search_button").addClass("ui-disabled");
			} else {
				$("#search_button").removeClass("ui-disabled");
				$("#search_button").removeAttr("disabled");
			}
	});

	$("#update_dialog_btn").bind("tap", function(){
		$("dd.edited_book_title").text($("#edited_title").val());
		$("dd.edited_book_author").text($("#edited_author").val());
	});


	$(window).bind("load", function(){
		if (document.URL.indexOf("index_m.html")) {
			$(window).bind("scroll", function(){
				var scrollHeight = $(document).height();
				var scrollPosition = $(window).height() + $(window).scrollTop();
				var nextPage = $("#hidden_info").attr("next");
				var scrollStatus = (scrollHeight - scrollPosition) / scrollHeight;
				if ((scrollStatus <= 0.05) && nextPage.length != 0) {
						$.ajax({
									url: ($("#hidden_info").attr("search"))? "search" : "books",
									data: ($("#hidden_info").attr("search"))? {view: "m", page: nextPage, search_string: $("#search").val()} : {view: "m", page: nextPage},
						}).done(function(data){
								var nextPageData = $("a[page_num='" + nextPage + "']");
								if (nextPageData.length == 0) {
									$("ul#books_index").append($(data).find("a[name='each_book_link']"));
								}
								$("#hidden_info").attr("next", $(data).find("#hidden_info").attr("next"));
						}).fail(function(data){
							$("#fail_read_dialog").popup("open");
						});
				} else if ((scrollStatus == 0) && nextPage.length == 0) {
					$("#end_read_dialog").popup("open");
					window.scrollBy(0, -10);
				}
			});
		}
	});

	$("[name='close_btn']").bind("tap", function(){
		$("#end_read_dialog").popup("close");
		$("#fail_read_dialog").popup("close");
	});

});
