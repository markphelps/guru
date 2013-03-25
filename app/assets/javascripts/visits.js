//= require fullcalendar.min

$('#calendar').fullCalendar({
  events: {
    url: "#{member_visits_path(@member, format: :json)}"
  }
});
