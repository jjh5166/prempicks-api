threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

preload_app!

port ENV.fetch('PORT') { 5050 }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch('RAILS_ENV') { 'development' }

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
