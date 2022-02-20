require 'rails_helper'

RSpec.describe "<model>User", type: :model do
  describe ":validation check" do
    before do
      @user = User.create(name: "Tester", email: "Tester1@email.com", password: "Tester", password_confirmation: "Tester")
    end

    context ":setting Testuser" do
      it "is valid with name, email, password, password_confirmation set by Factory bot" do
        expect(@user).to be_valid
      end
    end

    context ":name validation" do
      it "is invalid without a name" do
        @user.name = nil
        @user.valid?
        expect(@user.errors[:name]).to include("can't be blank")
      end

      it "has not too long name" do
        user = User.new(name: "a" * 51)
        user.valid?
        expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
      end
    end

    context ":email validation" do
      it "is invalid without a email" do
        user = User.new(email: "  ")
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "has not too long email" do
        user = User.new(email: "a" * 244 + "@example.com")
        user.valid?
        expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
      end

      it "accept vaild addresses if email is vaild" do
        valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user = User.new(name: "Tom", email: "Tom@email.com", password: "Testuser",
                          password_confirmation: "Testuser")
          user.email = valid_address
          expect(user).to be_valid
        end
      end

      it "is invalid with a duplicate email address" do
        user = User.new(name: "Mom", email: "Tester1@email.com", password: "Tester", password_confirmation: "Tester")
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
      end

      it "is invalid with a duplicate email address" do
        User.create(name: "Tom", email: "Tom@email.com", password: "Testuser",
          password_confirmation: "Testuser")
        user = User.new(name: "Mom", email: "Tom@email.com", password: "Tester",
          password_confirmation: "Tester")
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
      end
    end

    context ":password validation" do
      it "is invalid with a password that is only composed of space key" do
        user = User.new(name: "Tom", email: "Tom@email.com", password: " " * 6,
                        password_confirmation: " " * 6)
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end

      it "is invslid with a password that is less than 6-length" do
        user = User.new(name: "Tom", email: "Tom@email.com", password: "Testuser",
                      password_confirmation: "Testuser")
        user.password = user.password_confirmation = "a" * 5
        user.valid?
        expect(user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
    end
  end

  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "has method[authenticated?] that return false for a user with nil digest" do
    user = User.new(name: "Tester", email: "Tester1@email.com", password: "Testuser",
                    password_confirmation: "Testuser")
    expect(user.authenticated?(:remember, '')).to eq false
  end

  describe ":dependent test" do
    context "if user is quit" do
      let!(:article) { FactoryBot.create(:article) }

      it "one's article(s) is deleted" do
        user = User.find(article.user_id)
        expect do
          user.destroy
        end.to change(Article, :count).by(-1)
      end
    end
  end

  describe ":follow and unfollow" do
    before do
      @user = FactoryBot.create(:user, :activated)
      @other = FactoryBot.create(:user, :activated)
      @user.follow(@other)
    end

    context "follow" do
      it "suceeds" do
        aggregate_failures do
          expect(@user.following?(@other)).to be_truthy
          expect(@other.followers.include?(@user)).to be_truthy
        end
      end
    end

    context "unfollow" do
      it "suceeds" do
        @user.unfollow(@other)
        expect(@user.following?(@other)).to be_falsy
      end
    end
  end
end
