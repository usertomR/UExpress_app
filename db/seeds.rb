# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者ユーザー(1人)
User.create!(name: "Administrator", email: "administrator@gmail.com",
             password: "LearnRails", password_confirmation: "LearnRails",
             admin: true, activated: true)

# 一般ユーザー
User.create!(name: "teruo", email: "teruo@gmail.com",
             password: "teruo", password_confirmation: "teruo",
             admin: false, activated: true)

User.create!(name: "hattori", email: "hattori@gmail.com",
             password: "hattori", password_confirmation: "hattori",
             admin: false, activated: true)

User.create!(name: "akira", email: "akira@gmail.com",
             password: "akira", password_confirmation: "akira",
             admin: false, activated: true)

User.create!(name: "red pepper", email: "red pepper@gmail.com",
             password: "唐辛子", password_confirmation: "唐辛子",
             admin: false, activated: true)

# テストユーザー(1人)
User.create!(name: "Test_User", email: "testuser@understandexpress.com",
  password: "testuser", password_confirmation: "testuser",
  admin: false, activated: true)

# フォロー・フォロワー
user = User.first
users = User.all
following = users[1..2]
follower = users[2]
following.each { |followed| user.follow(followed) }
follower.follow(user)

# 記事へのnice
articles = Article.take(2)
articles.each do |article|
  users[1..2].each do |u|
    u.sum_nice_per_user << article
  end
end
