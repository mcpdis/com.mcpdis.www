listen 80
worker_processes 2
user "cyx", "cyx"
pid "/var/run/unicorn.pid"
stderr_path "/var/log/unicorn/stderr.log"
stdout_path "/var/log/unicorn/stdout.log"
