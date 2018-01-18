class CommentsController < ApplicationController

  # guests cannot create comments
  before_action :require_sign_in

  # ensure that unauthorized users can not delete comments
  before_action :authorize_user, only: [:destroy]

  def create
# find correct post and creat a new comment with comment_params. we assign the comment's user to current_user, which returns the signed-in user instance.
    @post = Post.find(params[:post_id])
    comment = @post.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      flash[:notice] = "Comment saved successfully."
# redirect to posts show view, successfully
      redirect_to [@post.topic, @post]
    else
      flash[:alert] = "Comment failed to save."
# redirect to posts show view, failure
      redirect_to [@post.topic, @post]
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    comment = @post.comments.find(params[:id])

    if comment.destroy
      flash[:notice] = "Comment was deleted."
      redirect_to [@post.topic, @post]
    else
      flash[:alert] = "Comment couldn't be deleted. Try again."
      redirect_to [@post.topic, @post]
    end
  end

  private

# private method that white lists the parameters we need to create comments
  def comment_params
    params.require(:comment).permit(:body)
  end

# allows the comment owner or an admin to delete comments. unauthorized users are redirected to the post show view.
  def authorize_user
    comment = Comment.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = "You do not have permission to delete a comment."
      redirect_to [comment.post.topic, comment.post]
    end
  end

end
