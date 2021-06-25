require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Article, type: :model do
  describe 'validations' do
    describe 'it validates title' do
      it { should validate_presence_of :title  }
    end
  end

end