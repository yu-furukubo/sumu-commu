class Public::CommunityMembersController < ApplicationController
  before_action :authenticate_member!

  def index
  end
end
