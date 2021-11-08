class User < ApplicationRecord
    before_save :downcase_email
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255},
                      format: {with: VALID_EMAIL_REGEX},
                      uniqueness: {case_sensitive: false}
    

    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true  
    
    #渡された文字列の「BCrypt」のハッシュ値を返す
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    

        private

            #メールアドレスを全て小文字にする。DBによって大文字小文字を区別する物もある
            def downcase_email
                self.email = email.downcase
            end

end
