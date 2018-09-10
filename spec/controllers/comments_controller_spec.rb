require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "comments#create action" do
    it "should allow users to create comments on grams" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { gram_id: gram.id, comment: { message: "Sally sells sea shells" } }

      expect(response).to redirect_to root_path
      expect(gram.comments.length).to eq 1
      expect(gram.comments.first.message).to eq "Sally sells sea shells"
    end

    it "should require a user to be logged in to comment on   gram" do
      gram = FactoryBot.create(:gram)

      post :create, params: { gram_id: gram.id, comment: { message: "I'm not logged in" } }

      expect(response).to redirect_to new_user_session_path
    end

    it "should return http status code of not found is the gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { gram_id: "BLAH BLAH", comment: { message: "But there's no gram" } }

      expect(response).to have_http_status :not_found
    end

  end

end
