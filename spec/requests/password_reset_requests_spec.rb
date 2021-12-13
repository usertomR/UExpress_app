require 'rails_helper'

RSpec.describe "<request>PasswordReset", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }

  # edit,updateアクションなどへのテストで必要です。
  before { user.create_reset_digest }

  describe "def new" do
    it "returns http success" do
      get "/password_resets/new"
      aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response.body).to include '送信'
      end
    end
  end

  describe "def create" do
    # メールアドレスが無効
    it "fails create with invalid email" do
      post password_resets_path, params: { password_reset: { email: "" } }
      aggregate_failures do
        expect(response).to have_http_status(200)
        expect(response.body).to include "パスワード再設定"
      end
    end

    # メールアドレスが有効
    it "succeeds create with valid email" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      aggregate_failures do
        expect(user.reset_digest).not_to eq user.reload.reset_digest
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "def edit" do
    # メールアドレスが無効
    context "when user sends correct token and wrong email" do
      before { get edit_password_reset_path(user.reset_token, email: "") }

      it "fails" do
        expect(response).to redirect_to root_path
      end
    end

    # 無効なユーザ
    context "when not activated user sends correct token and email" do
      before do
        user.toggle!(:activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
      end

      it "fails" do
        expect(response).to redirect_to root_path
      end
    end

    # メールアドレスが有効で、トークンが無効
    context "when user sends wrong token and correct email" do
      before { get edit_password_reset_path("wrong", email: user.email) }

      it "fails" do
        expect(response).to redirect_to root_url
      end
    end

    # メールアドレスもトークンも有効
    context "when user sends correct token and email" do
      before { get edit_password_reset_path(user.reset_token, email: user.email) }

      it "succeeds" do
        aggregate_failures do
          expect(response).to have_http_status(200)
          expect(response.body).to include "新パスワード入力"
        end
      end
    end
  end

  describe "def update" do
    # 無効なパスワードとパスワード確認
    context "when user sends wrong password" do
      before do
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "foobaz",
                  password_confirmation: "barquux"
                }
              }
      end

      it "fails" do
        aggregate_failures do
          expect(response).to have_http_status(200)
          expect(response.body).to include "新パスワード入力"
        end
      end
    end

    # パスワードが空
    context "when user sends blank password" do
      before do
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "",
                  password_confirmation: ""
                }
              }
      end

      it "fails" do
        aggregate_failures do
          expect(response).to have_http_status(200)
          expect(response.body).to include "新パスワード入力"
        end
      end
    end

    # 有効なパスワードとパスワード確認
    context "when user sends correct password" do
      before do
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "foobaz",
                  password_confirmation: "foobaz"
                }
              }
      end

      it "succeeds" do
        aggregate_failures do
          expect(is_logged_in?).to be_truthy
          expect(response).to redirect_to user
          expect(user.reload.reset_digest).to eq nil
          expect(response).to redirect_to user
        end
      end
    end
  end

  describe "def check_expiration" do
    context "when user updates after 3 hours" do
      before do
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "foobar",
                  password_confirmation: "foobar"
                }
              }
      end

      it "fails" do
        expect(response).to redirect_to new_password_reset_url
      end
    end
  end
end
