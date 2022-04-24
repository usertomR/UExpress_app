require "rails_helper"

RSpec.describe "<mailer>UserMailer", type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      aggregate_failures do
        expect(mail.subject).to eq "アカウント有効化メール/UExpress"
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["noreply@understandexpress.net"])
      end
    end

    it "renders the body" do
      aggregate_failures do
        expect(mail.html_part.body).to match user.name
        expect(mail.html_part.body).to match user.activation_token
        expect(mail.html_part.body).to match CGI.escape(user.email)
        expect(mail.text_part.body).to match user.name
        expect(mail.text_part.body).to match user.activation_token
        expect(mail.text_part.body).to match CGI.escape(user.email)
      end
    end
  end

  describe "password_reset" do
    let(:user) { FactoryBot.create(:user, :activated) }
    before { user.reset_token = User.new_token }
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("パスワード再設定/UExpress")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@understandexpress.net"])
    end

    it "renders the body" do
      expect(mail.html_part.body).to match user.reset_token
      expect(mail.html_part.body).to match CGI.escape(user.email)
      expect(mail.text_part.body).to match user.reset_token
      expect(mail.text_part.body).to match CGI.escape(user.email)
    end
  end
end
