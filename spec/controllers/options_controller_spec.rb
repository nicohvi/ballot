require 'rails_helper'

describe OptionsController do
  
  shared_context "authenticated" do
    let(:user) { create :user }

    before :each do
      session[:user_id] = user.id
    end
  end
  
  shared_context "guest_cookie" do
    let(:token) { SecureRandom.uuid }

    before :each do
      cookies[:guest_token] = token
    end
  end

  context "voting" do
    
    context "open/closed" do
      let(:open_poll)   { create :poll }
      let(:closed_poll) { create :closed_poll }

      it "allows votes for open polls" do
        expect{ post :vote, poll_id: open_poll, option_id: open_poll.options.first }.to change(Vote, :count).by(1)
      end

      it "does not allow votes for closed polls" do
        expect{ post :vote, poll_id: closed_poll, option_id: closed_poll.options.first }.to_not change(Vote, :count)
      end
    end

    context "as a guest" do
      include_context "guest_cookie"  
      let(:poll)            { create :poll }
      let(:restricted_poll) { create :restricted_poll }      
      let(:option)          { Option.first }

      it "stores the user as nil when a guest votes" do
        post :vote, poll_id: poll, option_id: option
        expect(poll.votes.length).to eq(1)
        expect(poll.votes.last.user).to be_nil
      end

      it "stores a guest token when a guest votes" do 
        post :vote, poll_id: poll, option_id: option
        expect(poll.votes.last.guest_token).to eq(token)
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

      it "doesn't allow guest votes for restricted polls" do
        expect { post :vote, poll_id: restricted_poll, 
        option_id: restricted_poll.options.first }.to_not change{ Vote.count } 
      end
    end

    context "logged in" do
      include_context "authenticated"
      let(:poll)            { create :poll }
      let(:restricted_poll) { create :restricted_poll }
      let(:option)          { Option.first }

      it "stores the user upon voting for an option" do
        post :vote, poll_id: poll, option_id: option
        expect(option.votes.count).to eq(1)
        expect(option.votes.first.user).to eq(user)
      end 

      it "allows users to vote for restricted polls" do
        expect { post :vote, poll_id: restricted_poll, 
        option_id: restricted_poll.options.first }.to change{ Vote.count }
      end
    end
  end
end
