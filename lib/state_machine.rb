# frozen_string_literal: true

require_relative "state_machine/version"
require_relative "state_machine/state_machine"
require_relative "state_machine/transition"
require "nanites"

# Generic state machine
# Supports branches
module StateMachine
  include Nanites

  # Raised if transition can't be executed
  class TransitionError < StandardError; end
  # Internal state machine error
  class StateMachineError < StandardError; end
end
