Project.destroy_all

Project.create!([{
  name: "Girls Get Science",
  project_type: "event",
  date: "May 4, 2019",
  attendees: "100",
  supplies_budget: "300"
},
{
  name: "Newport Mills",
  project_type: "event",
  date: "April 29, 2019",
  attendees: "40",
  supplies_budget: "150"
},
{
  name: "Art of Math",
  project_type: "class",
  date: "April 24, 2019",
  attendees: "10",
  supplies_budget: "200"
},
{
  name: "Flora Singer Week 1",
  project_type: "camp",
  date: "June 22, 2019",
  attendees: "35",
  supplies_budget: "350"
},
{
  name: "Chemistry",
  project_type: "class",
  date: "April 30, 2019",
  attendees: "10",
  supplies_budget: "150"
},
{
  name: "Crime Scene",
  project_type: "party",
  date: "July 11, 2019",
  attendees: "12",
  supplies_budget: "40"
}])

p "Created #{Project.count} projects"
