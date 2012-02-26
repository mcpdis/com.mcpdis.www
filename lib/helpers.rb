module MCPDIS
  module Helpers
    def time_ago(time, now = Time.now.utc)
      diff = (now - time).to_i

      if diff < 60
        t(:x_seconds_ago, count: diff)
      elsif diff < 3600
        t(:x_minutes_ago, count: diff / 60)
      elsif diff < 86400
        t(:x_hours_ago, count: diff / 3600)
      else
        t(:x_days_ago, count: diff / 86400)
      end
    end

    def localization
      {
        x_seconds_ago: {
          one:   "%{count} second ago",
          zero:  "%{count} seconds ago",
          other: "%{count} seconds ago"
        },

        x_minutes_ago: {
          one:   "%{count} minute ago",
          zero:  "%{count} minutes ago",
          other: "%{count} minutes ago"
        },

        x_hours_ago: {
          one:   "%{count} hour ago",
          zero:  "%{count} hours ago",
          other: "%{count} hours ago"
        },

        x_days_ago: {
          one:   "%{count} day ago",
          zero:  "%{count} days ago",
          other: "%{count} days ago"
        }
      }
    end

    def t(key, args = {})
      if args.has_key?(:count)
        pluralization =
          case args[:count]
          when 0 then :zero
          when 1 then :one
          else :other
          end

        localization[key][pluralization] % args
      else
        localization[key] % args
      end
    end

    def current_user
      authenticated(User)
    end

    def has_error?(model, att)
      model.errors.has_key?(att)
    end

    def send_wap_header!
      headers["Content-Type"] = "application/xhtml+xml"
    end

    def mote_vars(content)
      super.merge(path: req.path, current_user: current_user)
    end

    def under?(fragment, path)
      path.start_with?(fragment)
    end

    def in?(fragment, path)
      path == fragment
    end

  end
end
