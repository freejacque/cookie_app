# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
Recipe.destroy_all

ph = User.create(name: "Phil",   email: "philco@ga.co", role: "patissiere", password: "beth")
pj = User.create(name: "PJ",     email: "pj@ga.co",     role: "baker",      password: "christie")
tr = User.create(name: "Travis", email: "trav@ga.co",   role: "baker",      password: "malsy")
ol = User.create(name: "Olivia", email: "olivia@ga.co", role: "customer",   password: "phil")

cc = Recipe.create(name: "Chocolate Chip", cost: 12.50, total_cookies: 0)
sd = Recipe.create(name: "Snicker Doodle", cost: 11.00, total_cookies: 0)

ph.favorite_recipe = cc
pj.favorite_recipe = sd
tr.favorite_recipe = cc
ol.favorite_recipe = sd

ph.save
pj.save
tr.save
ol.save

