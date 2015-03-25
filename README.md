# Cobra Khan Academy

...takes the idea of Khan Academy and apply it to martial arts education. This is not meant to be a substitute to actually practicing under a quality instructor, but rather to fill in gaps and aid in one's practice.

This app is a simple organization of "instructionals" under a hierarchy  "topics". In theory, its application is not limited to martial arts; it could benefit any art that can be organized as a hierarchy. The sample application uses Brazilian Jiu-jitsu, a martial art often likened to "a game of kinetic chess", to demonstrate the benefits of hierarchical organization of knowledge. 

See it in action [here](https://murmuring-badlands-8038.herokuapp.com/)

## Technologies

The tools I used to build this app include, but are not limited to:

* Ruby on Rails 4.2
* Active Admin
* Bootstrap 3
* Elasticsearch
* Postgresql

## Issues

* Importing topics with hierarchy using a CSV file is rather finicky because of the Ancestry gem's parent_id= method, which sets the parent by calling unscoped_find with the supplied id. If the parent does not exist, ActiveRecord raises a RecordNotFound exception. This is problematic if you want to validate all rows of the CSV before saving. I've circumvented this by rescuing the exception and storing the given id into a virtual attribute and then setting the parent in a before_save callback. If a record with the given id still does not exist, an exception is raised and the import halts. I am currently thinking of a graceful way to handle this error.

* Visiting the admin section using the admin link in the navbar does not load the active admin CSS. However, visiting the admin page directly or refreshing the page after following a link does load the CSS. This does not seem to be a common issue with Active Admin.

