# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

space = Space.first_or_create()

space.roots << Directory.find_or_create_by(
  {
    name: 'Misc. Books',
    code: 'QmbedetDXupE9hceDF6DNsPd8ZLmL63zSFWkGctYx82QPb'
  }
)

space.roots << Directory.find_or_create_by(
  {
    name: 'Hugo Award Winners',
    code: 'Qmcga3rUYN3YYgYVHsibrHodFCaCEyCmTX3EA1TYEYX9gT'
  }
)

