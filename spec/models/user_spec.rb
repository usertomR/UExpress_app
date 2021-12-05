require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with name, email, password, password_confirmation" do
    user = User.new(name: "Tom", email: "Tom@email.com", password: "Testuser",
                    password_confirmation: "Testuser")
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a email" do
    user = User.new(email: "  ")
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "has not too long name" do
    user = User.new(name: "a" * 51)
    user.valid?
    expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end

  it "has not too long email" do
    user = User.new(email: "a" * 244 + "@example.com")
    user.valid?
    expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
  end

  it "accept vaild addresses if email is vaild" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp
                         alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user = User.new(name: "Tom", email: "Tom@email.com", password: "Testuser",
                      password_confirmation: "Testuser")
      user.email = valid_address
      expect(user).to be_valid
    end
  end

  it "reject invalid address if email is invalid" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user = User.new(name: "Tom", email: "Tom@email.com", password: "Testuser", password_confirmation: "Testuser")
      user.email = invalid_address
      expect(user).not_to be_valid
    end
  end

  it "is invalid with a duplicate email address" do
    User.create(name: "Tom", email: "Tom@email.com", password: "Testuser",
      password_confirmation: "Testuser")
    user = User.new(name: "Mom", email: "Tom@email.com", password: "Tester",
      password_confirmation: "Tester")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

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
    expect(user.errors.full_messages).to include(
      "Password is too short (minimum is 6 characters)"
    )
  end

  it "has method[authenticated?] that return false for a user with nil digest" do
    user = User.new(name: "Tom", email: "Tom@email.com", password: "Testuser",
      password_confirmation: "Testuser")
    expect(user.authenticated?(:remember, '')).to eq false
  end
end
