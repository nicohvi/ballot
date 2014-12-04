require 'rails_helper'

describe PollsController do
 
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
 
  context "poll creation" do
    let(:invalid_poll)  { { name: nil } }
    let(:poll)          { assigns(:poll) }
    
    it "doesn't create an invalid poll" do
      post :create, poll: invalid_poll
      expect(assigns(:poll)).to be_a_new(Poll)  
    end
    
    it "creates a poll with valid parameters" do
      expect { post :create, poll: attributes_for(:poll) }.to change(Poll, :count).by(1)
    end

    it "redirects to the edit action upon poll creation" do
      post :create, poll: attributes_for(:poll)
      expect(response).to redirect_to edit_poll_url(Poll.first)
    end

    context "as a guest" do
      it "sets the owner as *nil*" do
        post :create, poll: attributes_for(:poll)
        expect(poll.owner).to be_nil
      end

      it "sets the guest_token attribute" do
        post :create, poll: attributes_for(:poll)
        expect(poll.guest_token).to_not be_nil
      end

      it "sets a permanent cookie with the guest token" do
        post :create, poll: attributes_for(:poll)
        expect(cookies[:guest_token]).to eq(assigns(:current_user).token)
      end
    end

    context "logged in" do
      include_context "authenticated"

      it "sets the owner" do
        post :create, poll: attributes_for(:poll)
        expect(poll.owner).to eq(user)
      end
    end
   
  end  
 
  context "poll manipulation" do
    let(:other_poll)  { create :poll }
 
    context "logged in" do
      let(:poll)        { create :poll, owner: user }
      let(:closed_poll) { create :closed_poll, owner: user }
      let(:other_closed_poll) { create :closed_poll }
      include_context "authenticated"
  
      it "closes a poll associated with a user" do
        post :close, id: poll
        expect(assigns(:poll).closed?).to eq(true)
      end
  
      it "doesn't close polls associated with others" do
        post :close, id: other_poll
        expect(assigns(:poll).closed?).to eq(false)
      end

      it "opens a poll associated with a user" do
        post :open, id: closed_poll
        expect(assigns(:poll).closed?).to eq(false)
      end

      it "doesn't open polls associated with others" do
        post :open, id: other_closed_poll
        expect(assigns(:poll).closed?).to eq(true)
      end
    end

    context "guest" do
      include_context "guest_cookie"
      let(:poll) { create :guest_poll, guest_token: token }
      let(:closed_poll) { create :closed_guest_poll, guest_token: token }
      let(:other_closed_poll) { create :closed_guest_poll }

      it "closes a poll associated with a user" do
        post :close, id: poll
        expect(assigns(:poll).closed?).to eq(true)
      end
  
      it "doesn't close polls associated with others" do
        post :close, id: other_poll
        expect(assigns(:poll).closed?).to eq(false)
      end

      it "opens a poll associated with a user" do
        post :open, id: closed_poll
        expect(assigns(:poll).closed?).to eq(false)
      end

      it "doesn't open polls associated with others" do
        post :open, id: other_closed_poll
        expect(assigns(:poll).closed?).to eq(true)
      end
    end
  end
  
end
