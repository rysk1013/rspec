class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy, :show]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path
    else
      @post = Post.find(params[:id])
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user)
  end

  private
  def post_params
    params.require(:post).permit(:text, :image).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
