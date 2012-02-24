$:.unshift(*Dir["./vendor/*/lib"])

require "base64"
require "cuba"
require "cuba/contrib"
require "digest/md5"
require "digest/sha1"
require "mote"
require "ohm"
require "ohm/contrib"
require "scrivener"
require "securerandom"
require "shield"

# Let's declare this here so that PBKDF2 is also required.
Shield::Password.strategy = Shield::Password::PBKDF2
