require 'capistrano/recipes/deploy/scm'

default_run_options[:pty] = true # Needed for debian based servers
set :ssh_options, {:forward_agent => true}
 
namespace :deploy do
  desc "Set up the deployment structure"
  task :setup, :except => { :no_release => true } do
    run "mkdir -p #{deploy_to}"
    run_gregarious "[ -d #{deploy_to}/.git ] || git clone -q #{repository} #{deploy_to}"
    unversioned_dirs.each { |d| run "mkdir -p #{deploy_to + '/' + d}" } if exists? :unversioned_dirs
  end
 
  desc "Update the deployed code"
  task :default, :except => { :no_release => true } do
    fetch
    deploy.check_yr_head if fetch(:pedantic_remote, false) && branch !~ /HEAD/
    update_code
    orphans if fetch(:look_for_orphans, false)
  end
  
  desc "Fetches the latest from the repo"
  task :fetch do
    run_gregarious "cd #{deploy_to} ; git fetch -q origin"
  end
  
  desc "Aborts if remote's HEAD is different than ours"
  task :check_yr_head do
    remote = capture("cd #{deploy_to} ; git show-ref origin/#{branch}").split[0]
    local = `git show-ref #{branch}`.split[0]
    abort "It looks like you haven't pushed your changes yet. Aborting
    Your  HEAD is #{local[0,7]}
    Their HEAD is #{remote[0,7]}" if local != remote
  end  
  
  desc "Does a git reset to get the repo looking like branch"
  task :update_code do
    run "cd #{deploy_to} ; git reset --hard origin/#{branch}"
  end
  
  desc "Reports back on remote files that didn't come from git, or aren't ignored by git"
  task :orphans do
    orphans = capture "cd #{deploy_to} ; git ls-files -o"
    unless orphans.empty?
      logger.important <<-EOF 
        The following files are present in the deployment, and are unaccounted for
        You may want to manually slay them, or else add them to .gitignore
        
        #{orphans} 
      EOF
    end
  end
  
  desc "Rollback a single commit"
  task :rollback, :except => { :no_release => true } do
    set :branch, "HEAD^"
    default
  end
end

#
# Runs the given command via cap's wrapper, which handles things like ssh host
# key messages, passphrase prompts, and the like
#
def run_gregarious(cmd)
  run cmd do |ch,stream,text|
    ch[:state] ||= { :channel => ch }
    output = Capistrano::Deploy::SCM.new(:git, self).handle_data(ch[:state], stream, text)
    ch.send_data(output) if output
  end
end