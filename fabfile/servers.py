from fabric.api import *
import os

env.key_filename    = os.path.expanduser('~/.ssh/id_rsa')

# def localhost():
#  env.hosts     = ['localhost']
#  env.db_host   = env.local_db_host
#  env.db_name   = env.local_db_name
#  env.db_user   = env.local_db_user
#  env.db_pass   = env.local_db_pass
#  env.server    = 'localhost'

def krmg():
  env.user          = 'deploy'
  env.hosts         = ['krmg.se']
  env.www_root      = '/srv/site/tictail/public_html'
  env.db_name       = 'tictail'
  env.db_host       = 'localhost'
  env.db_user       = 'root'
  env.db_pass       = 'brocketino'
  env.key_filename  = '%s/fabfile/deploy_id_rsa' % os.path.abspath(os.path.join(os.path.realpath(os.path.dirname(__file__)), os.path.pardir)) 
