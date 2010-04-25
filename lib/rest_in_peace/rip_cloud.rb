require 'grit'
class RIPCloud
  
  def initialize(project_root)
    @settings = ProjectSettings.new(project_root)
  end
  
  def deploy

    create_rackup_config

    migrate_databases

    repo = create_git_repository

    if commit_latest_changes(repo)
      
      puts "Changes committed to git repository"
      
      create_heroku_application unless heroku_remote_exists?

      push_changes_to_heroku
      
      sync_databases
      
    else
      puts "Failed to make commit to Git repository"
    end
    
  end
  
  def create_rackup_config
    ServerManager.new(@settings.project_root).create_rackup_config
  end
  
  def migrate_databases
    
    Migration.new.migrate(@settings.project_root)
    
  end
  
  def heroku_remote_exists?
    
    exists = true # Pessimistic, dont want to create Heroku apps left and right
    
    Dir.chdir(@settings.project_root) do
      remotes = `git remote show`
      exists = false if remotes.match("heroku").to_s != "heroku"
    end
    
    exists
    
  end
  
  def create_git_repository
    
    unless File.exists?(File.join(@settings.project_root, ".git"))
      
      Dir.chdir(@settings.project_root) do
        system("git init")
      end
      
    else
      puts "Git repository already exists"
    end

    repo = Grit::Repo.new(@settings.project_root)
    
  end

  def commit_latest_changes(repo)
    repo.add(@settings.project_root)
    repo.commit_all("Rest in Peace: Deployment to Heroku at #{Time.now.to_s}")
  end

  def create_heroku_application
    
    Dir.chdir(@settings.project_root) do
      heroku_app = @settings.get_config_options["heroku_app"] || ""
      system "heroku create #{heroku_app} --stack bamboo-ree-1.8.7"
    end
    
  end

  def push_changes_to_heroku
    
    Dir.chdir(@settings.project_root) do
      system "git push heroku master"
    end
    
  end
  
  def sync_databases
    Dir.chdir(@settings.project_root) do
      system "heroku db:push sqlite://#{@settings.database_directory}/development.sqlite3"
    end    
  end

end