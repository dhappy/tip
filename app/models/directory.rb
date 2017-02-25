require 'net/http'

class Directory < Entry
  has_and_belongs_to_many :references, join_table: :directories_references

  @types = []
  @types[1] = 'Directory'
  @types[2] = 'Blob'
  @types[4] = 'Link'
  
  def references
    if super.empty?
      listing = Entry.ls(self.code)
      links = listing[:Objects].collect{ |o| o[:Links] }.flatten

      binding.pry

      this = super
      this += links.map do |link|
        Reference.find_or_create_by(
          {
            name: link[:Name],
            entry: Entry.find_or_create_by(
              {
                code: link[:Hash],
                type: @types[link[:Type]]
              }
            )
          }
        )
      end
    end
    
    super
  end
end
