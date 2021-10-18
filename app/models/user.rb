class User < ApplicationRecord
  has_secure_password

  # 追加
  # validates
  validates :name, presence: true,
                  length: { 
                     maximum: 30, 
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
end
