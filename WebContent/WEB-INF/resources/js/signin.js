/* JS for sign in page */

$(function() {
	
	$("#signin-form").submit(function() {
		var username = $("#username").val();
		var pwd = $("#password").val();
		var pwdMd5 = md5(pwd);
		Util.log("md5 pwd: " + pwdMd5);
		$.ajax({
			type : "post",
			url : "user/login",
			dataType : "json",
			data : {
				loginName : username,
				loginPwd : pwdMd5
			},
			success : function(data, textStatus, jqXHR) {
				var result = data.result;
				switch (result) {
				case "0":
					// login success
					location.href = "history";
					
					break;

				default:
					alert("login failed");
					break;
				}
			},
			error : function(jqXHR) {
				alert("login error");
			}
			
		});
		return false;
	});
});