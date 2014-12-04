require 'rails_helper'

describe OptionsController do

  context "voting" do

    context "as a guest" do
      let(:poll)    { create :poll_with_options }
      let(:option)  { Option.first }

      it "stores the user as nil when a guest votes" do
        post :vote, poll_id: poll, option_id: option
        expect(poll.votes.length).to eq(1)
        expect(poll.votes.last.user).to be_nil
      end

      it "stores a guest token when a guest votes" do 
        post :vote, poll_id: poll, option_id: option
        expect(poll.votes.last.guest_token).to_not be_nil 
      end

      it "doesn't allow a guest multiple votes" do
        post :vote, poll_id: poll, option_id: option
        expect { post :vote, poll_id: poll, option_id: option }
        .to_not change{ Vote.count }
      end

      it "allows a guest to change his vote" do
        post :vote, poll_id: poll, option_id: option
        post :vote, poll_id: poll, option_id: Option.second
        expect(option.votes.count).to eq(0)
        expect(Option.second.votes.count).to eq(1)
        expect(poll.votes.length).to eq(1)
      end

    

    end
  end
end
