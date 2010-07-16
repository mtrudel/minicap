# Where should we put our deployed application
set :deploy_to, "/wherever/you/want/it/"

# The repository storing our application
set :repository, "repo_url_here"

# The branch you want to deploy from (the origin/ is needed)
set :branch, "origin/master"

# The hostname(s) you want to deploy to
role :app, "example.com"

# The username you want to log in to the servers with
set :user, "johndoe"

# Set this to abort deployments when you have unpushed changes
#set :pendantic_remote, true

# Set this to have cap sweep your deployment and look for orphaned files
#set :look_for_orphans, true

# Any directories listed here will be created in deploy_to during setup, and 
# will be left untouched (and unversioned) between commits
set :unversioned_dirs, %w( dir1 dir2 )