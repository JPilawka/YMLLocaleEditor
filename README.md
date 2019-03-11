# README
* Ruby version
  2.5
  
* System dependencies
Requires 
  Ruby on rails >5
  Vue
  PostgreSQL database locally or remote (configuration)

* Configuration

* Database creation
    in terminal (in the app catalogue):
        >rake db:create

* Database initialization
    in terminal (in the app catalogue):
        >rake db:migrate

# YMLLocaleEditor

Simple app for editing localization files in YAML format. You can choose file from server, edit all text values (no key editing possible, as they are restricted in the final application) and save it to server and commit changed file to github.

Application base on PostgreSQL database, where temporary informations are stored and manipuleted.

Also uses my Very Simple Pagination script
