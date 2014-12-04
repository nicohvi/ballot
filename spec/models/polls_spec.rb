require 'rails_helper'

describe Poll do

  context "closing polls" do
    let(:poll) { create :poll }
    let(:closed_poll) { create :poll, closed: true }

    it "opens the poll" do
      closed_poll.open!
      expect(closed_poll.closed?).to eq(false)
    end

    it "closes the poll" do
      poll.close!
      expect(poll.closed?).to eq(true)
    end
  end
end
