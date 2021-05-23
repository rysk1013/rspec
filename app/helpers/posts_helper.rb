module PostsHelper
  def find_liked(post, user)
    Like.find_by(post_id: post.id, user_id: user.id)
  end

  def check_user(post, user)
    user_signed_in? && post.user_id == user.id
  end
end
