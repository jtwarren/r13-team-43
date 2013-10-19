class Group
  include MongoMapper::Document

  many :challenges

  key :name, String, required: true
  key :description, String

  userstamps!
  timestamps!

  scope :recent, where().sort(:created_at).limit(2)

  def users
    User.where(group_ids: id).all
  end
end
