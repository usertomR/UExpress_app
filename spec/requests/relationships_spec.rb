require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>Relationships", type: :request do

  describe ":Relationships#create" do
    let(:post_request) { post relationships_path }

    context "when not logged in" do
      it "doesn't change Relationship's count" do
        expect { post_request }.to change(Relationship, :count).by(0)
      end

      it "redirects to login_url" do
        expect(post_request).to redirect_to login_url
      end
    end
  end

  describe ":Relationships#destroy" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:delete_request) { delete relationship_path(other_user) }

    before { user.following << other_user }

    context "doesn't change Relationship's count" do
      it "because you do not login" do
        aggregate_failures do
          expect { delete_request }.to change(Relationship, :count).by(0)
        end
      end

      it "so, redirects to login_url" do
        expect(delete_request).to redirect_to login_url
      end
    end

    context "change Relationship's count" do
      it "because you login" do
        log_in_as(user)
        expect { delete_request }.to change(Relationship, :count).by(0)
      end
    end
  end
end
