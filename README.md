# Minicap

Minicap replaces the stock [capistrano](http://capify.org) recipes with a small, git-centric deployment strategy that eschews the power and flexibility of capistrano's (excellent, btw) default recipes, and replaces them with something smaller, faster and easier to grok.

Minicap is formalization of some work we've been doing with side project deployments at [well.ca](http://well.ca), originally inspired by Chris Wanstrath's [take](http://github.com/blog/470-deployment-script-spring-cleaning) on the subject. I got tired of maintaining separate yet nearly identical `deploy.rb` files in every side project, and realized where there was commonality, there was an opportunity to factor some behaviour up into stock recipes. Now the project `deploy.rb` files just contain a bunch of `set` statements, and a few (very minor) amendments to the minicap recipes.

Minicap requires that you use git as a repository, and that `git` is present
on the server. Deployments are not atomic (but since they're based on `git reset --hard`, they're pretty damn close). 

Minicap also has two features that the stock deployment recipes lack;

 1. Better (or at least more transparent) support for shared files. Since your deployment is just a git repo, files that need to persist between deployments can just live right in your server's working copy. Minicap has an optional task (enabled by enabling `look_for_orphans`) which scans for untracked files on your remote repo. Since any shared files should probably be in your `.gitignore` anyway, this really just reinforces a best practice. 

 2. Checking for unpushed changes. If you enable `pedantic_remote`, deployments will fail if your local HEAD is newer than the branch pulled down on the remote server. This is usually indicative of your forgetting to do a `git push` before a `cap deploy`, and helps prevent those 'why didn't my deployment change anything?' moments.

## Coming soon

 * Better multistage support. This will probably just lean on cap's multistage support, but I may make it a little cleaner
 * Transparent support for templated files. No more jumping through hoops to get a `database.yml` file up to production