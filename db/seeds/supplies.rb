Supply.destroy_all

Supply.create!([{
  name: "glue",
  store: "Amazon",
  store_link: "http://www.amazon.com",
  estimated_price: "5",
  quantity_needed: "300"
},
{
  name: "Newport Mills",
  type: "event",
  date: "April 29, 2019",
  attendees: "40",
  supplies_budget: "150"
},
{
  name: "Art of Math",
  type: "class",
  date: "April 24, 2019",
  attendees: "10",
  supplies_budget: "200"
},
{
  name: "Flora Singer Week 1",
  type: "camp",
  date: "June 22, 2019",
  attendees: "35",
  supplies_budget: "350"
},
{
  name: "Chemistry",
  type: "class",
  date: "April 30, 2019",
  attendees: "10",
  supplies_budget: "150"
},
{
  name: "Crime Scene",
  type: "party",
  date: "July 11, 2019",
  attendees: "12",
  supplies_budget: "40"
}])

p "Created #{Project.count} projects"
