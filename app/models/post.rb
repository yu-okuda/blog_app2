class Post < ApplicationRecord
  belongs_to :user

  def redis_access
    REDIS.zincrby "posts", 1, self.id
  end

  def redis_page_view
    REDIS.zscore("posts", self.id).floor
  end

  def Post.most_popular(limit: 2)
    most_popular_ids = REDIS.zrevrangebyscore "posts", "+inf", 0, limit: [0, limit]
    where(id: most_popular_ids).sort_by{ |post| most_popular_ids.index(post.id.to_s) }
  end

end
