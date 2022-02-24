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

User.create!(name: "hattori", email: "hattori@gmail.com",
             password: "hattori", password_confirmation: "hattori",
             admin: false, activated: true)

# Articleクラス用
Article.create!(title: "First Example", accuracy_text: 1, difficultylevel_text: 1,
                articletext: "This app's first article!", Eschool_level: false,
                JHschool_level: true, Hschool_level: false, user_id: User.first.id)

Article.create!(title: "Example-正しさの説明-", accuracy_text: 4, difficultylevel_text: 3,
                articletext: "文章の正確さを5段階で評価する。確実に正しいことしか記事に書かれていなければ" +
                "5で、正しいか分からない部分やわかりやすいけれど間違っている部分が多ければ評価が下がる。",
                Eschool_level: false, JHschool_level: true, Hschool_level: true, user_id: User.first.id)

Article.create!(title: "Example-文章難易度の説明-", accuracy_text: 3, difficultylevel_text: 3,
                articletext: "文章難易度を5段階で評価する。多くの人が流し読みで完全に理解できる文章なら1にして、" +
                "構造が複雑な文が多い文章や、内容を理解し辛い文章なら5にする。",
                Eschool_level: false, JHschool_level: true, Hschool_level: true, user_id: User.first.id)

Article.create!(title: "Example-正しさ1の例-", accuracy_text: 1, difficultylevel_text: 1,
                articletext: "UExpress(本アプリ)の製作者は人間ではない。",
                Eschool_level: true, JHschool_level: false, Hschool_level: false, user_id: User.first.id)

Article.create!(title: "Example-正しさ2の例-", accuracy_text: 2, difficultylevel_text: 2,
                articletext: "ウサイン・ボルトは100mの世界記録保持者。2002年から2017年までの現役時代は数々の記録を樹立し" +
                "人類史上最速のスプリンターと評された。全盛期には、稲妻を意味する「aaaaa」の愛称で呼ばれた。(3文目間違い)",
                Eschool_level: true, JHschool_level: false, Hschool_level: false, user_id: User.first.id)

Question.create!(title: "2次方程式について", accuracy_text: 2, difficultylevel_text: 2,
                 questiontext: "2次方程式って何？おいしいの？", Eschool_level: true, JHschool_level: false,
                 Hschool_level: false, solve: false, user_id: User.second.id)

Question.create!(title: "古文について", accuracy_text: 2, difficultylevel_text: 2,
                 questiontext: "古文の試験受けまぁす。・・・<ピピピピ>オワッチャッタァ!", Eschool_level: true, JHschool_level: false,
                 Hschool_level: false, solve: false, user_id: User.second.id)

Question.create!(title: "背理法がわからない", accuracy_text: 5, difficultylevel_text: 5,
                 questiontext: "青○ャートの115ページの背理法の証明のこの部分がわかんないっす。教えて下さい", Eschool_level: true, JHschool_level: false,
                 Hschool_level: false, solve: false, user_id: User.second.id)
# フォロー・フォロワー
user = User.find(1)
users = User.all
following = users[1..2]
follower = users[2]
following.each { |followed| user.follow(followed) }
follower.follow(user)

# 記事へのnice
articles = Article.find(1, 5)
articles.each do |article|
  users[1..2].each do |u|
    u.sum_nice_per_user << article
  end
end
