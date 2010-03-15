ReST in Peace
=============

Minimal web framework with a focus on simplicity. Powered by Sinatra and DataMapper.

Setup
-----

Get the Gem

	gem install rest_in_peace
	
Getting Started
---------------

1. Generate the project skeleton
		rip blogger

2. Move into the project directory
		cd blogger
	
3. Generate model and controller
		script/define Post title:string body:string

4. Migrate database
		script/migrate

5. Start server
		script/server

6. Browse to http://localhost:4567/post