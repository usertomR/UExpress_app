require 'rails_helper'

RSpec.describe "<request>Staticpages", type: :request do
  describe "get /home" do
    context ":works well" do
      it "returns http success" do
        get '/home'
        expect(response).to have_http_status(:success)
      end

      it "gives correct title" do
        get '/home'
        expect(response.body).to include "Home | UExpress"
      end
    end
  end

  describe "get root_url" do
    context ":works well" do
      it "returns http success" do
        get '/'
        expect(response).to have_http_status(:success)
      end

      it "gives correct title" do
        get '/'
        expect(response.body).to include "Home | UExpress"
      end
    end
  end
end
