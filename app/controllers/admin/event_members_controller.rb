class Admin::EventMembersController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @event = Event.find(params[:event_id])
    event_member = event.event_members.find(params[:id])
    if event_member.destroy
      redirect_to admin_event_path(event)
    else
      flash.now[:notice] = "イベントメンバーの削除に失敗しました。"
      @event_members = @event.event_members
      render template: "admin/events/show"
    end
  end
end
