require 'rails_helper'

RSpec.describe 'POST /api/users/login', type: :request do
  let(:user) { Fabricate(:user) }
  let(:url) { '/api/users/login' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      decoded_token = decoded_jwt_token_from_response(response)
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }
    
    it 'returns unathorized status' do
      expect(response.status).to eq 422
    end
  end
end

RSpec.describe 'DELETE /api/users/logout', type: :request do
  let(:url) { '/api/users/logout' }

  it 'returns 200, no content' do
    delete url
    expect(response).to have_http_status(200)
  end
end