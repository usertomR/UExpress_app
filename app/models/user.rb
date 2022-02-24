class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  # association
  has_many :articles, dependent: :destroy
  has_many :questions, dependent: :destroy
  # ややこしいが、SNS・railsコード側では、follower:自分をフォローする人/follow:自分がフォローする人
  # 一方、DB側では、follower:誰かにフォローする人/followed:誰かからフォローされる人
  # DB側では、自分がフォローする場合、自分はfollower
  has_many :active_relationships, class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy,
                                   inverse_of: :follower
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy,
                                   inverse_of: :followed
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # 記事のnice数を記録するために記入
  has_many :nice_to_articles, class_name: "NiceToArticle",
                                dependent: :destroy,
                                inverse_of: :user
  has_many :sum_nice_per_user, through: :nice_to_articles, source: :article

  # 記事のブックマーク機能
  has_many :article_bookmarks, class_name: "ArticleBookmark",
                                dependent: :destroy,
                                inverse_of: :user
  has_many :sum_bookmark_per_user, through: :article_bookmarks, source: :article

  # 記事の「気になるボタン」に関するの実装
  has_many :curious_questions, classname: "CuriousQuestion",
                                dependent: :destroy,
                                inverse_of: :user
  has_many :sum_curious_per_user, through: :curious_questions, source: :question

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列の「BCrypt」のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンとダイジェストが一致したらtrueを返す
  # モデル内の[self]は省略可能。[self.send]は[send]と同じ
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated, true)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
      update_columns(reset_digest: User.digest(reset_token),
                               reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # 以下3つは、メソッド内でself(呼び出し元のインスタンス変数)を省略している.
  # 以下3つが使える理由は、このファイルで、has_many :following・・・を記述しているから。
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

        private

  # メールアドレスを全て小文字にする。DBによって大文字小文字を区別する物もある
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成及び代入する
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
