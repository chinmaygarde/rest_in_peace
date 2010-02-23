RESTed DB (Rough Draft. Not final yet)
======================================

Easily expose database entities as REST resources.

Setup
-----

Get the Gem

	gem install rested_db
	
Getting Started
---------------

1. Generate the project skeleton
		rested todo_list

2. Move into the project directory
		cd todo_list
	
3. Generate model and controller
		script/define Item name:string completed:boolean

4. Migrate database
		script/migrate

5. Start server
		script/server

6. Browse to http://localhost:4567/item