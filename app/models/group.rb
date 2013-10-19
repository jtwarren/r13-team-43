class Group
  include MongoMapper::Document

  many :challenges

  key :name, String, required: true
  key :description, String

  def users
    User.where(group_ids: id).all
  end
end
