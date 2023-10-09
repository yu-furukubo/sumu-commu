class Admin::EventMembersController < ApplicationController
  def destroy
    event = Event.find(params[:event_id])
    event_member = event.event_members.find(params[:id])
    if event_member.destroy
      redirect_to admin_event_path(event)
    else
      render template: "admin/events/show"
    end
  end
end
