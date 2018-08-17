require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, params: {gram: {message: "HelloWorld"}}
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {gram: {message: "HelloWorld"}}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("HelloWorld")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user
      
      gram_count = Gram.count
      post :create, params: {gram: {message:''}}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end

  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryBot.create(:gram)
      get :show, params: {id: gram.id}
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, params: {id:'TACOCAT'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#edit action" do
    it "should successfully show the edit form if the gram is found" do
      gram = FactoryBot.create(:gram)
      get :edit, params: {id: gram.id}
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      get :edit, params: {id: 'TACOCAT'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do
    it "should allow users to successfully update grams" do
      gram = FactoryBot.create(:gram, message: "Initial Value")
      patch :update, params: {id: gram.id, gram: { message: "Changed Value"}}
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed Value"
    end

    it "should have http 404 error if gram is not found" do 
      patch :update, params: {id: 'foo', gram: {message: "phooey"} }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram = FactoryBot.create(:gram, message: "Initial Value")
      patch :update, params: {id: gram.id, gram: { message: ""}}
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial Value"
    end
  end

describe "grams#destroy action" do
  it "should allow a user to destroy grams" do
    gram = FactoryBot.create(:gram)
    delete :destroy, params: {id: gram.id}
    expect(response).to redirect_to root_path
    #!Q - how does this work? We are redining gram as the using the gram.id of the gram that has been destroyed. Do we even need that line, or would the test work with only the second one?
    gram = Gram.find_by_id(gram.id)
    expect(gram).to eq nil
  end

  it "should return a 404 message if we cannot find a gram with the id that is specified" do
    delete :destroy, params: {id: "blah blah blah"}
    expect(response).to have_http_status(:not_found)
  end
end

end


# !Q - How do you avoid the problem of making sure the tests are correct? Who watches the watchmen?
# !Q - What are all these http status codes? Are they returned standard in browswers, or are they a rails thing?
