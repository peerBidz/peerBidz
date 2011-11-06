$(function() {
  if ($("#notifications").length > 0) {
    setTimeout(updateNotifications, 5000);
  }
});

function updateNotifications () {
	var user_id = $(".notification:last-child").attr("data-user-id")
	var after = $(".notification:last-child").attr("data-time")
	$.getScript("/notifications.js?user_id=" + user_id + "&after=" + after )
	setTimeout(updateNotifications, 5000);
}