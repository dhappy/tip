class Reference < ActiveRecord::Base
  has_and_belongs_to_many :directories, join_table: :directories_references
  belongs_to :entry
end
