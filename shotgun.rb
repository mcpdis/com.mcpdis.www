$:.unshift(*Dir["./vendor/*/lib"])

require "cuba"
require "cuba/contrib"
require "ohm"
require "ohm/contrib"
require "mote"
require "scrivener"
require "shield"

# Let's declare this here so that PBKDF2 is also required.
Shield::Password.strategy = Shield::Password::PBKDF2
