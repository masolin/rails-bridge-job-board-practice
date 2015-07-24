# Rails Bridge Job Board Practice
[![Code Climate](https://codeclimate.com/github/masolin/rails-bridge-job-board-practice/badges/gpa.svg)](https://codeclimate.com/github/masolin/rails-bridge-job-board-practice)

This project is my practice of rails bridge job board. I tried to reproduce job board website without reading tutorial and used some tips from rails 102 and rails best practices.

## Difference from original Rails Bridge Job Board
* Add a show page for each jobs.
* Add validations.
* Add other useful fields (salary, phone, email) to jobs.
* Display jobs sortable with jquery data_tables.
* Add simple tags and scope-based search for tags.
* Add a user model and auth with Devise.
* Use RSepc, factory_girl and faker to test model and controller.
* Use `.includes` to prevent n + 1 queries.
* Add `dependent: :destroy` into `job_tags` model to prevent useless entries
  exist when job or tag deleted
* Use heroku to deploy


## Demo
[My Rails 101s Practice Hosted on Heroku.](https://calm-mesa-6313.herokuapp.com)