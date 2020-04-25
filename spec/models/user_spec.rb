require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should belong_to(:organization) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
end