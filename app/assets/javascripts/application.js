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
		setTimeout(function() {
			tips.removeClass("ui-state-highlight", 1500);
		}, 500);
	}

	function checkLength(o, n, min, max) {
		if (o.val().length > max || o.val().length < min) {
			o.addClass("ui-state-error");
			updateTips("Length of " + n + "must be between " + min + " and " + max + ".");
			return false;
		} else {
			return true;
		}
	}

	$("#dialog-form").dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		buttons: {
			"OK": function() {
				var user_name = $("#lending_user_name").on("textchange", function() {});
				var bValid = true;

				allFields.removeClass("ui-state-error");

				bValid = bValid && checkLength(user_name, "利用者名", 1, 25);

				if (bValid) {
					$("#lending_book").submit();
					$(this).dialog("close");
				}
			},
			"キャンセル": function() {
			allFields.val("").removeClass("ui-state-error");
				$(this).dialog("close");
			}
		},
		close: function() {
			allFields.val("").removeClass("ui-state-error");
		}
	});

	$("#lending_book_button")
		.click(function() {
			$("#dialog-form").dialog("open");
	});


	$("[name=book_select]").change(function() {
		$("#lending_book_button").removeAttr("disabled");
		$("#lending_book_button").removeClass("ui-state-disabled");
		$("#lending_book_button").removeClass("ui-button-disabled");
		
		$("#return_book_button").removeAttr("disabled");
		$("#return_book_button").removeClass("ui-state-disabled");
		$("#return_book_button").removeClass("ui-button-disabled");
		
		$("#lending_book").attr("action", "/books/" + $(this).attr("book_id")  + "/lendings");
		$("#return_book").attr("action", "/books/" + $(this).attr("book_id") + "/lendings/" + $(this).attr("lending_id"));
	});


	$("#dialog-confirm").dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		buttons: {
			"OK": function() {
				$("#return_book").submit();
				$(this).dialog("close");
			},
			"キャンセル": function() {
				$(this).dialog("close");
			}
		}
	});
 	

	$("#return_book_button")
		.click(function() {
			$("#dialog-confirm").dialog("open");
	});

});

