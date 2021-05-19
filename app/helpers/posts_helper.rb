module PostsHelper
  def find_liked(post, user)
    Like.find_by(post_id: post.id, user_id: user.id)
  end
end
