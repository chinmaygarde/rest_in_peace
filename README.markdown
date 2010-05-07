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
		script/define Post title:string body:string has_many:comments
		
4. Add nested resources
		script/define Comment body:string belongs_to:post

To Deploy To The Cloud
----------------------

4. Deploy to Heroku
		script/cloud

For Local Development
---------------------

4. Migrate database
		script/migrate

5. Start server
		script/server

6. Browse to http://localhost:4567/post