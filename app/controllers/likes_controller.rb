class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @like = Like.create(post_id: params[:post_id], user_id: current_user.id)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @already_liked = Like.find_by(post_id: params[:post_id], user_id: current_user.id)
    @already_liked.destroy
    redirect_back(fallback_location: root_path)
  end
end
