set :application, "moabiter-kochkultur_de"
set :domain, "moabiter-kochkultur.de"
set :deploy_to, "/var/www/#{domain}"
#set :user, "deployer" # default ist der aktuelle User
set :use_sudo, false # Verwende kein sudo

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :subversion
set :repository,  "https://svn.codespaces.com/stadtmuster/svn/moabiter-kochkultur.de/trunk"
set :scm_username, "inka"
set :scm_password, "urtcsop."

role :app, "www.moabiter-kochkultur.de"
role :web, "www.moabiter-kochkultur.de"
role :db,  "www.moabiter-kochkultur.de", :primary => true
