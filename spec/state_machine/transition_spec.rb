# frozen_string_literal: true

RSpec.describe StateMachine::Transition do
  context "when initialized" do
    let :transition do
      described_class.create :first_step, :first, :second, ->(ctx) { puts "has context: #{!ctx.nil?}" }
    end

    it "has name assigned" do
      expect(transition.name).to eq :first_step
    end

    it "has 'from' assigned" do
      expect(transition.from).to eq :first
    end

    it "has 'to' assigned" do
      expect(transition.to).to eq :second
    end

    it "has 'condition' assigned" do
      expect(transition.condition.nil?).to be_falsey
    end
  end

  context "when executing with condition" do
    let :transition do
      described_class.create :first_step, :first, :second, ->(ctx) { ctx.fetch(:some_value, false) }
    end

    it "returns 'to' status on success" do
      result = transition.execute some_value: true

      expect(result.option.value).to eq :second
    end

    it "returns 'from' status on error" do
      result = transition.execute

      expect(result.option.value).to eq :first
      expect(result.messages.first).to eq "Transition not process as condition wasn't successful"
    end
  end

  context "when executing w/o condition" do
    let :transition do
      described_class.create :first_step, :first, :second
    end

    it "returns 'to' status on success" do
      result = transition.execute some_value: true

      expect(result.option.value).to eq :second
    end
  end

  context "when printing" do
    it "returns string representation" do
      t = described_class.new :first_step, :first, :second, ->(ctx) { puts "has context: #{!ctx.nil?}" }
      expected = "[first_step] first -> second (has condition: true)"

      expect(t.to_s).to eq expected
    end
  end
end
