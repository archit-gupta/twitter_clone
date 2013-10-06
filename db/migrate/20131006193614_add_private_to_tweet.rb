class AddPrivateToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :private, :boolean, :default => false
  end
end
