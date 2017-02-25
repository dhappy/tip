require 'net/http'

class Directory < Entry
  has_and_belongs_to_many :references, join_table: :directories_references

  def references
    if super.empty?
      listing = Entry.ls(code)
      links = listing[:Objects].collect{ |o| o[:Links] }.flatten

      super << links.map do |link|
        Reference.find_or_create_by(
          {
            name: link[:Name],
            entry: Entry.find_or_create_by(
              {
                code: link[:Hash],
                type: types[link[:Type]]
              }
            )
          }
        )
      end
    end
    
    super
  end
end
