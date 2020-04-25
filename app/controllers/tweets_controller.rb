class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_auth_token?
  before_action :check_for_admin, only: [:update, :destroy]
  
  def index
    if current_user.admin?
      @tweets = Tweet.all
    else
      @tweets = current_user.organization.get_all_tweets
    end
  end

  def create
    if params[:tweet][:message].blank?
      json_response(:not_found, 404, "Please proivde required parameters","")
      return
    end
    tweet = current_user.tweets.new(tweet_params)
    if tweet.save
      json_response(:ok, 200, "Tweet Created Successfully!", {id: tweet.id, tweet: tweet.message})
    else
      json_response(:false, 500, tweet.errors.full_messages, "")
    end
  end

  def update
    if @tweet.present?
      if params[:tweet][:message].blank?
        json_response(:not_found, 404, "Please proivde needed parameters","")
        return
      else
        @tweet.update_attributes(tweet_params)
        json_response(:ok, 200, "Tweet Updated Successfully!", {id: @tweet.id, tweet: @tweet.message})
      end
    else
      json_response(:false, 404, "No tweet of yours is present having id - #{params['id']}", "")
      return
    end
  end

  def destroy
    if @tweet.present?
      @tweet.destroy
      json_response(:ok, 200, "Tweet Deleted Successfully!", {id: @tweet.id, tweet: @tweet.message})
    else
      json_response(:false, 404, "No tweet of yours is present having id - #{params['id']}", "")
      return
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def check_for_admin
    if current_user.admin?
      @tweet = Tweet.find_by_id(params['id'])
    else
      @tweet = current_user.tweets.find_by_id(params['id'])
    end
  end

end
