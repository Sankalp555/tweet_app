class Organization < ApplicationRecord
  has_many :users

  def get_all_tweets
    return Tweet.where(user_id: self.users.pluck(:id))
  end

end
