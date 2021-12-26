release: rake db:migrate; rake queues:create
web: rake worker:run:production & bundle exec puma -t 5:5 -p ${PORT:-3000}
# NOTE the above web process is specific to codepraise; see below for generic version
# web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
# worker: bundle exec shoryuken -r ./workers/git_clone_worker.rb -C ./workers/shoryuken.yml