#Rails6のオートロードシステム「Zeitwerk（ツァイトベルク）」はlib以下（にあるvalidator）を読み込まないのでrequireが必要になる
require "validator/email_validator"

class User < ApplicationRecord
   before_validation :downcase_email
   has_secure_password

  # 追加
  # validates
   validates :name, presence: true,
                  length: { 
                     maximum: 30, 
                     allow_blank: true 
                  }
   validates :email, presence: true,
                  email: { 
                     allow_blank: true 
                  }
   
  # 追加
  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                       length: { 
                          minimum: 8 ,
                          allow_blank: true
                       },
                       format: { #書式チェック
                          with: VALID_PASSWORD_REGEX,
                          message: :invalid_password, 	# 追加
                          allow_blank: true
                       },
                       allow_nil: true

  ## methods
  # class method  ###########################
  class << self
   # emailからアクティブなユーザーを返す
   def find_by_activated(email)
     find_by(email: email, activated: true)
   end
 end
 # class method end #########################
 # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
 def email_activated?
   users = User.where.not(id: id)
   users.find_by_activated(email).present?
 end

 private
 # email小文字化
 def downcase_email
   self.email.downcase! if email
 end

end
