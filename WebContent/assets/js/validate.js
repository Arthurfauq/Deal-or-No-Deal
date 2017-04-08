$(document).ready(function() {
	$("form[name='gameForm']").validate({
		rules : {
			username: {
				required: true,
				minlength: 5
			}
			
		},
		messages: {
			username: {
				required: "You must enter a username.",
				minlength: "Username must be at least 5 characters."
			}
		},
		submitHandler: function(form) {
			form.submit();
		}
	});
});