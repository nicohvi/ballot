require 'rails_helper'

describe PollsController do
  
  shared_context "guest" do
    before :each do
      allow(controller).to receive(:current_user).and_return(Guest.new)
    end
  end

  context "poll creation" do
    include_context 'guest'
    let(:invalid_poll)  { { name: nil } }

    it "doesn't create an invalid poll" do
      post :create, poll: invalid_poll
      expect(assigns(:poll)).to be_a_new(Poll)  
    end

    it "creates a poll with valid parameters" do
      expect { post :create, poll: attributes_for(:poll) }.to change(Poll, :count).by(1)
    end

    it "redirects to the edit action upon poll creation" do
      post :create, poll: attributes_for(:poll)
      expect(response).to redirect_to edit_poll_url(Poll.last)
    end

    it "sets the owner as *nil* when no user is logged in" do
      post :create, poll: attributes_for(:poll)
      expect(Poll.first.owner).to be_nil
    end
  end  
end
