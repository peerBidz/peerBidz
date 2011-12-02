$(function() {
	if($("#notifications").length > 0) {
		setTimeout(updateNotifications, 1000);
	}
});
/*
$(function() {
	//if($("#current-price").length > 0) {
		setTimeout(updateItemPrice, 1000);
	//}
});
*/
function updateNotifications() {
	var user_id = $(".notifications").attr("data-user-id")
	$.getScript("/notifications.js?user_id=" + user_id)
	setTimeout(updateNotifications, 10000);
}
/*
function updateItemPrice() {
	alert("updateItemPrice")
	//$.getScript("/items.js")
	setTimeout(updateItemPrice, 10000);
}
*/