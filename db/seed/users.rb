User.destroy_all

User.create!([{
  name: "Joan",
  email: "joan@gradlab.com",
  password_digest:
},
{
  name: "Laura",
  email: "laura@quinby.com",
  password_digest:
},
{
  name: "Will",
  email: "will@whale.com",
  password_digest:
},
{
  name: "Frances",
  email: "frances_h@mom_of_two.com",
  password_digest:
},
{
  name: "Natalia",
  email: "natalia_g@hero.com",
  password_digest:
},
{
  name: "Angela",
  email: "sissy@boss.com",
  password_digest:
}])

p "Created #{User.count} users"
