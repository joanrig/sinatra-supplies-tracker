Project.destroy_all
Project.create!([{
  name: "Girls Get Science",
  project_type: "event",
  date: "May 4, 2019",
  attendees: "100",
  supplies_budget: "300.00",
  user_id: "1"
},
{
  name: "Newport Mills",
  project_type: "event",
  date: "April 29, 2019",
  attendees: "40",
  supplies_budget: "150",
  user_id: "2"
},
{
  name: "Art Of Math",
  project_type: "class",
  date: "April 24, 2019",
  attendees: "10",
  supplies_budget: "200",
  user_id: "3"
},
{
  name: "Flora Singer Week 1",
  project_type: "camp",
  date: "June 22, 2019",
  attendees: "35",
  supplies_budget: "350",
  user_id: "4"
},
{
  name: "Chemistry",
  project_type: "class",
  date: "April 30, 2019",
  attendees: "10",
  supplies_budget: "150",
  user_id: "2"
},
{
  name: "Tardis Launch",
  project_type: "party",
  date: "July 11, 2019",
  attendees: "1000",
  supplies_budget: "45000",
  user_id: "4"
}])

Supply.destroy_all
Supply.create!([{
  name: "glue",
  vendor: "Amazon",
  website: "http://www.amazon.com",
  unit_type: "gallon",
  price_per_unit: 5,
  user_id: "4"
},
{
  name: "PVC",
  vendor: "Home Depot",
  website: "http://www.homedepot.com",
  unit_type: "6 feet",
  price_per_unit: 4,
  user_id: "1"
},
{
  name: "paint",
  vendor: "Michaels",
  website: "http://www.michaels.com",
  unit_type: "gallon",
  price_per_unit: 9,
  user_id: "2"
},
{
  name: "clay",
  vendor: "Amazon",
  website: "http://www.amazon.com",
  unit_type: "20 pounds",
  price_per_unit: 40,
  user_id: "4"
},
{
  name: "sonic screwdriver",
  vendor: "Amazon",
  website: "http://www.amazon.com",
  unit_type: "box of 12",
  price_per_unit: 20,
  user_id: "4"
},
{
  name: "food coloring",
  vendor: "local grocery",
  website: "",
  unit_type: "box of 4",
  price_per_unit: 6,
  user_id: "3"
}])


ProjectSupply.destroy_all
ProjectSupply.create!([{
  project_id: "1",
  supply_id: "2"
},
{
  project_id: "2",
  supply_id: "5"
},
{
  project_id: "3",
  supply_id: "4"
},
{
  project_id: "4",
  supply_id: "3"
},
{
  project_id: "6",
  supply_id: "2"
},
{
  project_id: "3",
  supply_id: "1"
}])


User.destroy_all
User.create!([{
  name: "Joan",
  email: "joan@email.com",
  password: "test"
},
{
  name: "Wonder Woman",
  email: "wonder@wonder.com",
  password: "test"
},
{
  name: "Dr. Who",
  email: "who@who",
  password: "test"
}])
