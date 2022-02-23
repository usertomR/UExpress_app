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
    before do
      @user = FactoryBot.create(:user, :activated)
      @another = FactoryBot.create(:user, :activated)
      @user.following << @another
      @relationship = Relationship.where("followed_id = ?", @another.id)[0]
    end

    context "doesn't change Relationship's count" do
      it "because you do not login" do
        aggregate_failures do
          delete relationship_path(@relationship)
          expect {response}.to change(Relationship, :count).by(0)
        end
      end

      it "so, redirects to login_url" do
        delete relationship_path(@relationship)
        expect(response).to redirect_to login_url
      end
    end

    context "change Relationship's count" do
      it "because you login" do
        log_in_as(@user)
        expect { delete relationship_path(@relationship) }.to change(Relationship, :count).by(-1)
      end
    end
  end
end
