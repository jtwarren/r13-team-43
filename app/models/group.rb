class Group
  include MongoMapper::Document

  many :challenges

  key :name, String, required: true
  key :description, String

  userstamps!
  timestamps!

  scope :recent, sort(:created_at.desc).limit(5)

  def users
    User.where(group_ids: id).all
  end
end
