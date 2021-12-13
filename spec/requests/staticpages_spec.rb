require 'rails_helper'

RSpec.describe "<request>Staticpages", type: :request do
  describe "get /about" do
    context ":works well" do
      it "returns http success" do
        get '/about'
        expect(response).to have_http_status(:success)
      end

      it "gives correct title" do
        get '/about'
        expect(response.body).to include "About | UExpress"
      end
    end
  end

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

  describe "get /help" do
    context ":works well" do
      it "returns http success" do
        get '/help'
        expect(response).to have_http_status(:success)
      end

      it "gives correct title" do
        get '/help'
        expect(response.body).to include "Help | UExpress"
      end
    end
  end

  describe "get /contact" do
    context ":works well" do
      it "returns http success" do
        get '/contact'
        expect(response).to have_http_status(:success)
      end

      it "gives correct title" do
        get '/contact'
        expect(response.body).to include "Contact | UExpress"
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
