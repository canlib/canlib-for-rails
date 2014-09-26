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


$(function() {
		var dialog, form,

		user_name = $( "#user_name" )
		allFields = $( [] ).add( user_name ),
		tips = $( ".validateTips" );

		function updateTips( t ) {
			tips
				.text( t )
				.addClass( "ui-state-highlight" );
			setTimeout(function() {
				tips.removeClass( "ui-state-highlight", 1500);
			}, 500 );
		}

		function checkLength( o, n, min, max ) {
			if ( o.val().length > max || o.val().length < min ){
				o.addClass( "ui-state-error" );
				updateTips( "Length of " + n + " must be between " + min + " and " + max + "." );
				return false;
			} else {
				return true;
			}
		}

		function lendingBook() {
			var valid = true;
			allFields.removeClass( "ui-state-error ");

			valid = valid && checkLength( user_name, "user_name", 1, 25);

			if ( valid ) {
				dialog.dialog( "close" );
			}
			return valid;
		}

		dialog = $( "#dialog-form" ).dialog({
			autoOpen: false,
			height: 300,
			width: 350,
			modal: true,
			buttons: {
				"OK": lendingBook,
				"キャンセル": function() {
						dialog.dialog( "close" );
				}
			},
			close: function() {
				form[ 0 ].reset();
				allFields.removeClass( "ui-state-error" );
			}
		});

		form = dialog.find( "form" ).on( "submit", function( event ) {
			event.preventDefault();
			lendingBook();
		});

		$( "#lending-book" ).button().on( "click", function() {
			alert("テスト");
			dialog.dialog( "open" );
		});
});
