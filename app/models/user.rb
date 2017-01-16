class User < ApplicationRecord
	attr_accessor :remember_token
	before_save{self.email.downcase!}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates(:name, presence: true, length: {maximum: 50})
	validates(:email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX},
		uniqueness: {case_sensitive: false})
	has_secure_password
	validates(:password, presence:true, length:{minimum:6})

	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
	end

	def remember
		@remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(@remember_token))
	end

	def authenticate?(string)
		if remember_digest == nil
			return false
		else
			BCrypt::Password.new(remember_digest).is_password?(string)
		end
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

end
