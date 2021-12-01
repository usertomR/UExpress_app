# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者ユーザー(1人)
User.create!(name: "Administrator", email: "satouhiroshi95@gmail.com",
             password: "LearnRails", password_confirmation: "LearnRails",
             admin: true, activated: true)

# 一般ユーザー
User.create!(name: "teruo", email: "timekeeper@gmail.com",
             password: "owacchata", password_confirmation: "owacchata",
             admin: false, activated: true)
