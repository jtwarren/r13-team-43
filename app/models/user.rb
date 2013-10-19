class User
  include MongoMapper::Document
  include ActiveModel::SecurePassword

  has_secure_password

  key :email, String, required: true, unique: true
  key :password_digest, String
end
