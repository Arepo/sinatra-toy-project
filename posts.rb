class PostRepository < ROM::Repository::Base
  relations :posts

  def [](id)
    posts.where(id: id).one!
  end
end

rom = ROM.finalize.env

class Posts
end
