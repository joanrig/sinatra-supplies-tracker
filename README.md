## Welcome to your new  Supplies Tracker!

You can use this web app to create projects and then track supplies fo each project.

A project can be anything: a class you are teaching; a vacation; a home improvement ... basically anything that uses supplies.

You can create a project with just a name. After it's created you can add optional attributes including project type and attendees (attendees are useful if the project is an event like a party or camp etc.)

From any project page, you can click update supplies to add, subtract, or create new supplies for this project. Supplies can be created with just a name and can be updated with optional attributes including vendor name and price.  

Your dashboard (link on top of every page) shows all your projects and all your supplies.

I hope you can use this free app to track the supplies in your life!


## Blog Posts

You can read more about the development of this web app in these blog posts:

1. Part 1. MVC architecture
https://medium.com/@joanrigdon/my-first-sinatra-web-app-part-1-2377dcaebdef

2. Part 2. Dynamic routes, forms and parameters
https://medium.com/@joanrigdon/my-first-sinatra-web-app-part-2-routes-5191ca02933c

3. Part 3. Fixing privacy problems
https://medium.com/@joanrigdon/sinatra-web-app-privacy-problems-68b94a382471


## Videos

Here is a 10-minute video walkthrough of how this program works: https://www.loom.com/share/b7ba598fc12e41b6aa56a7937924dba8

If you are really bored, you can watch this screencast of me working on the project -- I solve a few problems, run into more, and don't worry... I solved the last problem shortly after I stopped recording!
https://www.loom.com/share/7079e5d82dc34f6c8833df4a79af6dd8


## Usage

To run this program,
1. clone this repo, then run 'bundle install'.
2. run rake db:migrate to set up the database with no data.
3. (optional) If you would like to experiment with seed data, you run rake db:seed.

At any point, you can reset the database by running:
1. rake db:drop
2. rake db:migrate
3. (optional) rake db:seed

After the database is set up, run 'shotgun' in terminal and you should see this:

== Shotgun/Thin on http://127.0.0.1:9393/
Thin web server (v1.7.2 codename Bachmanity)
Maximum connections set to 1024
Listening on 127.0.0.1:9393, CTRL+C to stop

Navigate to http://127.0.0.1:9393/ and you will see the project's landing page, a login page.
Click on the link at the bottom of the page to sign up for the service.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/space_missions. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The web app is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the SpaceMissions project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/space_missions/blob/master/CODE_OF_CONDUCT.md).
