listen 80
worker_processes 2
pid "/var/run/unicorn/unicorn.pid"
stderr_path "/var/log/unicorn/stderr.log"
stdout_path "/var/log/unicorn/stdout.log"
