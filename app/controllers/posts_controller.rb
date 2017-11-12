class PostsController < ApplicationController
  def index

    # we declare an instance variable @posts and assign it a collection of Post objects using the all method provided by ActiveRecord. all returns a collection of Post objects.
    @posts = Post.all
  end

  def show

    # we find the post that corresponds to the id in the params that was passed to  show and assign it to @post. Unlike in the index method, in the show method, we populate an instance variable with a single post, rather than a collection of posts.
    @post = Post.find(params[:id])
  end

  def new

    # we create an instance variable, @post, then assign it an empty post returned by Post.new.
    @post = Post.new
  end

  def create

   end

  def edit
  end
end
