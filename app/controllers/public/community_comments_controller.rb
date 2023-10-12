class Public::CommunityCommentsController < ApplicationController
  before_action :authenticate_member!

  def index
  end
end
