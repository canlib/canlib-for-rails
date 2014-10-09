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
//= require jquery_ujs
//= require_tree .

$(function() {
	var allFields = $([]).add($("#lending_user_name")),
	tips = $(".validateTips");

	function updateTips(t) {
		tips
			.text(t)
			.addClass("ui-state-highlight");
	}

	function checkLength(o, n, min, max) {
		if (o.val().length > max || o.val().length < min) {
			o.addClass("ui-state-error");
			updateTips(n + I18n.check_min + min + I18n.check_between + max + I18n.check_max);
			return false;
		} else {
			return true;
		}
	}

	$("#lending-dialog-form").dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		buttons: [{
			text: I18n.ok_button,
			click: function() {
				var user_name = $("#lending_user_name").on("textchange", function() {});
				var bValid = true;

				allFields.removeClass("ui-state-error");

				bValid = bValid && checkLength(user_name, I18n.label_user_name, 1, 25);

				if (bValid) {
					$("#lending_book").submit();
					$(this).dialog("close");
				}
			}
		},{
			text: I18n.cancel_button,
			click: function() {
			allFields.val("").removeClass("ui-state-error");
				$(this).dialog("close");
			}
		}],
		close: function() {
			allFields.val("").removeClass("ui-state-error");
		}
	});

	$("#lending_book_button")
		.click(function() {
			$("#lending-dialog-form").dialog("open");
	});


	$("[name=book_select]").change(function() {
		$("#lending_book_button").removeAttr("disabled");
		$("#return_book_button").removeAttr("disabled");
		$("#delete_book_button").removeAttr("disabled");
		$("#show_book_button").removeAttr("disabled");
		
		$("#lending_book").attr("action", "/books/" + $(this).attr("book_id")  + "/lendings");
		$("#return_book").attr("action", "/books/" + $(this).attr("book_id") + "/lendings/" + $(this).attr("lending_id"));
		$("#delete_book").attr("action", "/books/" + $(this).attr("book_id"));
		$("#show_book").attr("action", "/books/" + $(this).attr("book_id") + "/edit");
	});


	$("#lending-dialog-confirm").dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		buttons: [{
			text: I18n.ok_button,
			click: function() {
				$("#return_book").submit();
				$(this).dialog("close");
			}
		},{
			text: I18n.cancel_button,
			click: function() {
				$(this).dialog("close");
			}
		}]
	});
 	

	$("#return_book_button")
		.click(function() {
			$("#lending-dialog-confirm").dialog("open");
	});

	$("#delete-dialog-confirm").dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		buttons: [{
			text: I18n.ok_button,
			click: function() {
				$("#delete_book").submit();
				$(this).dialog("close");
			}
		},{
			text: I18n.cancel_button,
			click: function() {
				$(this).dialog("close");
			}
		}]
	});

	$("#delete_book_button")
		.click(function() {
			$("#delete-dialog-confirm").dialog("open");
	});

	$("#add-book-dialog-form").dialog({
		autoOpen: false,
		height: 300,
		width: 400,
		modal: true,
		buttons: [{
			text: I18n.ok_button, 
			click: function() {
				var title = $("#book_title").on("textchange", function() {});
				var author_name = $("#book_author_name").on("textchange", function() {});
				var bValid = true;

				allFields.removeClass("ui-state-error");

				bValid = bValid && checkLength(title, I18n.label_title, 1, 50);
				bValid = bValid && checkLength(author_name, I18n.label_author_name, 1, 30);

				if (bValid) {
					$("#add_book").submit();
					$(this).dialog("close");
				}
			}
		},{
			text: I18n.cancel_button,
			click: function() {
			allFields.val("").removeClass("ui-state-error");
				$(this).dialog("close");
			}
		}],
		close: function() {
			allFields.val("").removeClass("ui-state-error");
		}
	});

	$("#add_book_button")
		.click(function() {
			$("#add-book-dialog-form").dialog("open");
	});

	$("#update_button")
		.click(function() {
		$("#update-dialog-confirm").dialog("open");
	});

	$("#update-dialog-confirm").dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		buttons: [{
			text: I18n.ok_button,
			click: function() {
				$("form.edit_book").submit();
				$(this).dialog("close");
			}
		},{
			text: I18n.cancel_button,
			click: function() {
				$(this).dialog("close");
			}
		}]
	});

	clearradio();

});

	function clearradio() {
		var radio_btn_count =	$("[name=book_select]").length;
		for (i = 0; i < radio_btn_count; i++) {
			$("[name=book_select]")[i].checked = false;
		}
		$("#lending_book_button").attr("disabled", true);
		$("#return_book_button").attr("disabled", true);
		$("#delete_book_button").attr("disabled", true);
		$("#show_book_button").attr("disabled", true);
	}
