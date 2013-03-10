
from fabric.api import *
# from fabric.context_managers import *
# from fabric.utils import puts
from fabric.colors import red, green, yellow
from fabric.contrib import *
from fabric.contrib.project import *
# from fabric.contrib.files import *
from datetime import datetime
from servers import *

import os


env.local_dir       = '%s' % os.path.abspath(os.path.join(os.path.realpath(os.path.dirname(__file__)), os.path.pardir))
env.local_db_name   = 'go_aivars'
env.local_db_user   = 'root'
env.local_db_pass   = 'brocketino'
env.local_db_host   = '127.0.0.1'
env.local_code      = '%(local_dir)s/public_html' % env
env.timestamp       = datetime.now().strftime("%y%m%dT%H%M")

def pull():
  _pull_code()
  # _pull_db()

def _pull_code():
  local('rsync --delete'+
        ' --exclude "*.DS_Store"'+
        ' --exclude "*.swp"'+
        ' --exclude "*.gitignore"'+
        ' -pthrvz'+
        ' --rsh="ssh -i %(key_filename)s -l %(user)s"' % env+
        ' %(host)s:%(www_root)s/' % env+
        ' %(local_code)s/' % env
        )

  # def _pull_db(): 
  # local('mysqldump -u%(local_db_user)s -p%(local_db_pass)s --add-drop-table --no-data %(local_db_name)s | grep ^DROP | mysql -u%(local_db_user)s -p%(local_db_pass)s %(local_db_name)s' % env)
  # local('mysqldump -h%(db_host)s -u%(db_user)s -p%(db_pass)s %(db_name)s | mysql -u%(local_db_user)s -p%(local_db_pass)s %(local_db_name)s' % env)
  
  # Empty our database to avoid strange merges 
  # local('mysqldump -u%(local_db_user)s -p%(local_db_pass)s --add-drop-table --no-data %(local_db_name)s | grep ^DROP | mysql -u%(local_db_user)s -p%(local_db_pass)s %(local_db_name)s' % env)
  
  # Pipe the remote database to our local database thrugh a ssh tunnel 
  # local('ssh %(host)s -p%(port)s -l %(user)s -i %(key_filename)s "mysqldump -h%(db_host)s -u%(db_user)s -p%(db_pass)s %(db_name)s" | mysql -u%(local_db_user)s -p%(local_db_pass)s %(local_db_name)s' % env)

def push():
  sudo('chown -R %(user)s %(www_root)s' % env, shell=False)
  _push_code()
    # if console.confirm("Are you sure you want to push your local database (%(local_db_name)s) to %(host)s" % env, default=False):
    #   _push_db()
  sudo('chown -R www-data %(www_root)s' % env, shell=False)
  
def _push_code():
  print( yellow('Pushing local code base to %(host)s' %env, bold=True) )
  rsync_project('%(www_root)s' % env,'%(local_code)s/' % env, delete=True, exclude=['wusage', 'waff', 'cgi-bin', '.htaccess', '*.DS_Store','*.gitignore','wp-content/uploads/**','templates_c/**','sites/*/files/**','sites/*/private/**'])

def _push_db():
  print( yellow('Pushing local database to %(host)s' %env, bold=True) )
 
  # First we make a backup of the current databas
  run('mkdir -p db_backup')
  run('mysqldump -h%(db_host)s -u%(db_user)s -p%(db_pass)s %(db_name)s | gzip -9 > db_backup/%(host)s-%(db_name)s-%(timestamp)s.sql.gz' % env) 
 
  # Now we pipe our current database to the remote server over ssh
  local('mysqldump -h%(local_db_host)s -u%(local_db_user)s -p%(local_db_pass)s %(local_db_name)s | ssh -i %(key_filename)s %(user)s@%(host)s "mysql -h%(db_host)s -u%(db_user)s -p%(db_pass)s %(db_name)s"' % env)

