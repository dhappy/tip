class Entry < ActiveRecord::Base
    has_and_belongs_to_many :spaces
    has_and_belongs_to_many :directories

    serialize :names, Array
end
