require 'rails_helper'

RSpec.describe "Api::V1::Users::Registrations", type: :request do
  describe "POST /api/v1/signup" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            email: "test@example.com",
            password: "password123",
            password_confirmation: "password123",
            name: "Test User",
            bio: "Test bio"
          }
        }
      end

      before do
        headers = { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
        post "/api/v1/signup", params: valid_params.to_json, headers: headers
      end

      it "creates a new user" do
        expect {
          post "/api/v1/signup", params: valid_params.to_json, headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
        }.to change(User, :count).by(1)
      end

      it "returns a success message" do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Signed up successfully.")
      end

      it "returns the user data" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]).to have_key("id")
        expect(json_response["user"]).to have_key("email")
        expect(json_response["user"]).to have_key("name")
        expect(json_response["user"]).to have_key("bio")
        expect(json_response["user"]["email"]).to eq("test@example.com")
        expect(json_response["user"]["name"]).to eq("Test User")
        expect(json_response["user"]["bio"]).to eq("Test bio")
      end

      it "does not include password in response" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]).not_to have_key("password")
        expect(json_response["user"]).not_to have_key("password_confirmation")
      end
    end

    context "with invalid parameters" do
      context "when email is missing" do
        let(:invalid_params) do
          {
            user: {
              password: "password123",
              password_confirmation: "password123",
              name: "Test User"
            }
          }
        end

        before do
          headers = { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          post "/api/v1/signup", params: invalid_params.to_json, headers: headers
        end

        it "does not create a user" do
          expect {
            post "/api/v1/signup", params: invalid_params.to_json, headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          }.not_to change(User, :count)
        end

        it "returns unprocessable entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns error messages" do
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key("errors")
          expect(json_response["errors"]).to include("Email can't be blank")
        end
      end

      context "when password confirmation doesn't match" do
        let(:invalid_params) do
          {
            user: {
              email: "test@example.com",
              password: "password123",
              password_confirmation: "different_password",
              name: "Test User"
            }
          }
        end

        before do
          headers = { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          post "/api/v1/signup", params: invalid_params.to_json, headers: headers
        end

        it "does not create a user" do
          expect {
            post "/api/v1/signup", params: invalid_params.to_json, headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          }.not_to change(User, :count)
        end

        it "returns unprocessable entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns error messages" do
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key("errors")
          expect(json_response["errors"]).to include("Password confirmation doesn't match Password")
        end
      end

      context "when email is already taken" do
        let!(:existing_user) { User.create!(email: "existing@example.com", password: "password123", name: "Existing User") }

        let(:invalid_params) do
          {
            user: {
              email: "existing@example.com",
              password: "password123",
              password_confirmation: "password123",
              name: "Test User"
            }
          }
        end

        before do
          headers = { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          post "/api/v1/signup", params: invalid_params.to_json, headers: headers
        end

        it "does not create a user" do
          expect {
            post "/api/v1/signup", params: invalid_params.to_json, headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          }.not_to change(User, :count)
        end

        it "returns unprocessable entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns error messages" do
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key("errors")
          expect(json_response["errors"]).to include("Email has already been taken")
        end
      end

      context "when password is too short" do
        let(:invalid_params) do
          {
            user: {
              email: "test@example.com",
              password: "123",
              password_confirmation: "123",
              name: "Test User"
            }
          }
        end

        before do
          headers = { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          post "/api/v1/signup", params: invalid_params.to_json, headers: headers
        end

        it "does not create a user" do
          expect {
            post "/api/v1/signup", params: invalid_params.to_json, headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
          }.not_to change(User, :count)
        end

        it "returns unprocessable entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns error messages" do
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key("errors")
          expect(json_response["errors"]).to include(/Password is too short/)
        end
      end
    end

    context "with missing user wrapper" do
      let(:invalid_params) do
        {
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123",
          name: "Test User"
        }
      end

      before do
        headers = { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
        post "/api/v1/signup", params: invalid_params.to_json, headers: headers
      end

      it "returns parameter missing error" do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
