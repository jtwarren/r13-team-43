class Challenge
  include MongoMapper::Document

  belongs_to :group

  key :title, String
  key :description, String
end
