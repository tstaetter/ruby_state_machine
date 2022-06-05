# frozen_string_literal: true

module StateMachine
  # State machine transition
  class Transition
    attr_reader :name, :from, :to, :condition

    def initialize(name, from, to, condition = nil)
      @name = name
      @from = from
      @to = to
      @condition = condition
    end

    # Execute the transition
    # @param [Hash] context Optional context data
    # @return [Nanites::Result]
    def execute(**context)
      if condition.nil?
        Nanites::Result.success @to
      elsif condition.call(context)
        Nanites::Result.success @to
      else
        Nanites::Result.error @from, "Transition not process as condition wasn't successful"
      end
    rescue StandardError => e
      Nanites::Result.error e
    end

    def to_s
      "[#{@name}] #{@from} -> #{@to} (has condition: #{!@condition.nil?})"
    end

    class << self
      # Factory method for creating a transition object
      # @see Transiton#new for parameter descriptions
      def create(name, from, to, condition = nil)
        Transition.new name, from, to, condition
      end
    end
  end
end
