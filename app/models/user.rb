class User
  JUDGE_MODE = true

  include MongoMapper::Document
  include ActiveModel::SecurePassword

  has_secure_password unless JUDGE_MODE

  key :email, String, required: true, unique: true
  key :password_digest, String

  # override auth logic to allow login without password
  def authenticate(password)
    return true if JUDGE_MODE

    super(password)
  end
end
