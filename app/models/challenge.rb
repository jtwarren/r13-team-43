class Challenge
  include MongoMapper::Document

  belongs_to :group

  key :title, String, required: true
  key :description, String
end
