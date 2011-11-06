$(function() {
	if($("#notifications").length > 0) {
		setTimeout(updateNotifications, 1000);
	}
});
function updateNotifications() {
	var user_id = $(".notifications").attr("data-user-id")
	$.getScript("/notifications.js?user_id=" + user_id)
	setTimeout(updateNotifications, 10000);
}