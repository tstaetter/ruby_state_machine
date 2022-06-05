# frozen_string_literal: true

RSpec.describe StateMachine::StateMachine do
  context "when initialized" do
    it "has valid states set" do
      machine = described_class.new :first, :second, :third, initial: :first
      expect(machine.states).to eq %i[first second third]
    end

    it "has current state set to first elements of 'states'" do
      machine = described_class.new :first, :second, :third
      expect(machine.current).to eq :first
    end

    it "has current state set to value of 'params[:initial]'" do
      machine = described_class.new :first, :second, :third, initial: :third
      expect(machine.current).to eq :third
    end
  end

  context "when calling transitions" do
    let :machine do
      described_class.new :first, :second, :third, initial: :first
    end

    it "returns all available transitions" do
      machine.transition :first_step, :first, :second

      expect(machine.transitions.count).to eq 1
    end

    it "can call transition directly" do
      machine.transition :first_step, :first, :second

      expect(machine.respond_to?(:first_step)).to be_truthy
    end

    it "has 'to' state as new current state when transition executed transition" do
      machine.transition :first_step, :first, :second
      machine.first_step

      expect(machine.current).to eq :second
    end

    it "can execute 'next'" do
      machine.transition :first_step, :first, :second
      machine.next

      expect(machine.current).to eq :second
    end
  end
end
