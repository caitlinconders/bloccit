class AddSponsoredPostsToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :sponsored_post_id, :integer, foreign_key: true
  end
end
