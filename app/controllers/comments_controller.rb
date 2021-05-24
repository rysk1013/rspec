class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy]

  def create
    @comment = @post.comments.new(comment_params)
    if @comment.save
      redirect_to post_path(@post)
    else
      @comments = @post.comments.includes(:user)
      reidrect_back(fallback_location: post_path(@post))
    end
  end

  def destroy
    @comment = @post.comments.find_by(id: params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
