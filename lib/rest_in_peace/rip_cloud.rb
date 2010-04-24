class RIPCloud
  
  def initialize(project_root)
    @settings = ProjectSettings.new(project_root)
  end
  
  def deploy
    # Create GIT REepository
    repo = create_git_repository

    # Commit latest changes
    if commit_latest_changes(repo)
      puts "Commit made to Git repository"
    else
      puts "Failed to make commit to Git repository"
    end
    
    # Create heroku application
    # Push changes to heroku
    # Sync databases
    # Restart heroku app
  end
  
  def create_git_repository
    
    Dir.chdir(@settings.project_root) do
      system("git init")
    end

    repo = Grit::Repo.new(@settings.project_root)
    
  end

  def commit_latest_changes(repo)
    repo.add(@settings.project_root)
    repo.commit_all("Rest in Peace: Deployment to Heroku at #{Time.now.to_s}")
  end

  def create_heroku_application
    
  end

  def push_changes_to_heroku
    
  end
  
  def sync_databases
    
  end

  def restart_heroku_app
    
  end
  
end