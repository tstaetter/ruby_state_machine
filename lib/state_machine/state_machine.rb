# frozen_string_literal: true

module StateMachine
  # Base state machine
  class StateMachine
    attr_reader :states, :current, :context, :transitions

    # Create new state machine. The initial state is either determined by 'params[:initial]' or the first
    # element of 'states'
    # @param [Array] states An array of possible states
    # @param [Hash] params Optional parameters
    # @raise [StateMachineError] if no initial state could be determined
    def initialize(*states, **params)
      @current = params.fetch(:initial, states.first)

      raise StateMachineError, "Initial state not among the valid states: #{params.fetch(:initial)}" unless
        states.include?(@current)

      @context = params.fetch(:context, {})
      @states = states
      @transitions = {}
    rescue StandardError => e
      raise StateMachineError, "No initial state could be defined", e
    end

    # Add a transition
    # @param [Symbol] name
    # @param [Symbol] from
    # @param [Symbol] to
    # @param [Proc] condition
    # @raise [StateMachineError]
    def transition(name, from, to, condition = nil)
      raise StateMachineError, "From state '#{from}' not amongst valid states" unless @states.include?(from)
      raise StateMachineError, "To state '#{to}' not amongst valid states" unless @states.include?(to)

      @transitions[name] = Transition.create name, from, to, condition
    end

    # Progress to next state
    # @param [Hash] ctx optional context
    def next(**ctx)
      raise TransitionError, "No transition available" unless (t = @transitions.values.collect { |v|
                                                                 v if v.from.eql?(@current)
                                                               }.first)

      execute_transition t, **ctx
    end

    # TODO: Progress to previous state
    # @param [Hash] ctx optional context
    def previous(**ctx)
      raise TransitionError, "Not yet implemented: #{ctx}"
    end

    def method_missing(symbol, *args)
      raise TransitionError, "No transition with name #{symbol} found" unless (t = @transitions[symbol])

      execute_transition t, *args
    end

    def respond_to_missing?(method_name, _include_private = false)
      @transitions.key? method_name
    end

    private

    # Helper executing transition
    # @param [StateMachine::Transition] t
    # @param [Hash] ctx optional context values
    # @raise [TransitionError]
    def execute_transition(t, **ctx)
      result = t.execute **ctx

      case result.status
      in Nanites::Some
        @current = result.option.value
      else
        raise TransitionError, "Transition '#{t.name}' not successful. #{result.option.value}"
      end
    end
  end
end
