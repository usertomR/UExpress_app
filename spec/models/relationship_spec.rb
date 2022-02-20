require 'rails_helper'

RSpec.describe "<model>Relationship", type: :model do
  describe ":validation" do
    let(:user) { FactoryBot.create(:user, :activated) }
    let(:other) { FactoryBot.create(:user, :activated) }
    let(:relationship) { user.active_relationships.build(followed_id: other.id) }

    it "is valid with test data" do
      expect(relationship).to be_valid
    end

    it "is invaild without follower_id" do
      relationship.follower_id = nil
      expect(relationship).not_to be_valid
    end

    it "is invaild without followed_id" do
      relationship.followed_id = nil
      expect(relationship).to be_invalid
    end
  end
end
