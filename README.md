# Team 09 Directory of Activities
---

### Description
This is a web app for viewing the Faculty of Engineering's Directory of Activities.

### Significant Features/Technology
With this system you can:
- Create and view activities
- Send edit requests for activities with incorrect information
- Only have to update module information once, as it is updated everywhere at once
- Manage user permissions
- Use built-in analytics tools
- Add customisable learning objectives to an activity

### Special Development Pre-requisites
You will need
- Ruby 2.6.2 (with bundler)
- NodeJS

### Deployment
1) Ensure you are either on a campus computer, or running the university VPN that is running Linux
2) Clone or download the repo from Gitlab
3) Open a terminal and move into the cloned folder
4) Type `bundle install` to install gems
5) Type `bundle exec epi_deploy release -d demo` to deploy to the demo site. It may take a few minutes to deploy
6) Type `bundle exec cap demo deploy:seed` to add some base records to the database

### Customer Contact
Andrew Garrard <a.garrard@sheffield.ac.uk>
