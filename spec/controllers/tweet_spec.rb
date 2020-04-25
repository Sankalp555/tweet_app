require 'rails_helper'

RSpec.describe "Tweet Create", :type => :request do

  it "creates a Tweet" do
    headers = { "ACCEPT" => "application/json" }
    post "/api/tweets", :params => { :tweet => {:message => "My First Tweet"} }, :headers => headers

    expect(response.content_type) == "application/json"
    expect(response).to have_http_status(200)
  end

end