require 'rails_helper'

RSpec.describe "Api::V1::Reactions", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }
  let!(:user) { User.create!(email: "user@example.com", password: "password123", name: "Test User") }
  let!(:post_record) { Post.create!(title: "Test Post", content: "Test content", author: user) }

  describe "GET /api/v1/reactions" do
    let!(:reactions) do
      kinds = %w[like love laugh angry]
      kinds.map { |kind| Reaction.create!(kind: kind, user: user, reactionable: post_record) }
    end

    before do
      get "/api/v1/reactions", headers: headers
    end

    it "returns success status" do
      expect(response).to have_http_status(:ok)
    end

    it "returns all reactions" do
      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to be_an(Array)
      expect(json_response["data"].length).to eq(4)
    end

    it "returns pagination metadata" do
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("meta")
      expect(json_response["meta"]).to have_key("page")
      expect(json_response["meta"]).to have_key("per_page")
      expect(json_response["meta"]).to have_key("total")
    end

    context "with pagination" do
      before do
        get "/api/v1/reactions?per_page=2&page=1", headers: headers
      end

      it "respects per_page parameter" do
        json_response = JSON.parse(response.body)
        expect(json_response["data"].length).to eq(2)
      end
    end
  end

  describe "GET /api/v1/reactions/:id" do
    let!(:reaction) { Reaction.create!(kind: "like", user: user, reactionable: post_record) }

    context "when reaction exists" do
      before do
        get "/api/v1/reactions/#{reaction.id}", headers: headers
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the reaction" do
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(reaction.id)
        expect(json_response["kind"]).to eq("like")
        expect(json_response["reactionable_type"]).to eq("Post")
        expect(json_response["reactionable_id"]).to eq(post_record.id)
      end
    end

    context "when reaction does not exist" do
      before do
        get "/api/v1/reactions/99999", headers: headers
      end

      it "returns not found status" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/reactions" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          reaction: {
            kind: "love",
            user_id: user.id,
            reactionable_type: "Post",
            reactionable_id: post_record.id
          }
        }
      end

      it "creates a new reaction" do
        expect {
          post "/api/v1/reactions", params: valid_params.to_json, headers: headers
        }.to change(Reaction, :count).by(1)
      end

      it "returns created status" do
        post "/api/v1/reactions", params: valid_params.to_json, headers: headers
        expect(response).to have_http_status(:created)
      end

      it "returns the created reaction" do
        post "/api/v1/reactions", params: valid_params.to_json, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response["kind"]).to eq("love")
        expect(json_response["reactionable_type"]).to eq("Post")
        expect(json_response["reactionable_id"]).to eq(post_record.id)
      end
    end

    context "with invalid kind" do
      let(:invalid_params) do
        {
          reaction: {
            kind: "invalid_kind",
            user_id: user.id,
            reactionable_type: "Post",
            reactionable_id: post_record.id
          }
        }
      end

      it "does not create a reaction" do
        expect {
          post "/api/v1/reactions", params: invalid_params.to_json, headers: headers
        }.not_to change(Reaction, :count)
      end

      it "returns unprocessable entity status" do
        post "/api/v1/reactions", params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        post "/api/v1/reactions", params: invalid_params.to_json, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).to include(/Kind is not included in the list/)
      end
    end

    context "with missing required fields" do
      let(:invalid_params) do
        {
          reaction: {
            kind: "like"
          }
        }
      end

      it "does not create a reaction" do
        expect {
          post "/api/v1/reactions", params: invalid_params.to_json, headers: headers
        }.not_to change(Reaction, :count)
      end

      it "returns unprocessable entity status" do
        post "/api/v1/reactions", params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with duplicate reaction" do
      let!(:existing_reaction) { Reaction.create!(kind: "like", user: user, reactionable: post_record) }
      let(:duplicate_params) do
        {
          reaction: {
            kind: "like",
            user_id: user.id,
            reactionable_type: "Post",
            reactionable_id: post_record.id
          }
        }
      end

      it "does not create a duplicate reaction" do
        expect {
          post "/api/v1/reactions", params: duplicate_params.to_json, headers: headers
        }.not_to change(Reaction, :count)
      end

      it "returns unprocessable entity status" do
        post "/api/v1/reactions", params: duplicate_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/reactions/:id" do
    let!(:reaction) { Reaction.create!(kind: "like", user: user, reactionable: post_record) }

    context "with valid parameters" do
      let(:valid_params) do
        {
          reaction: {
            kind: "love"
          }
        }
      end

      before do
        patch "/api/v1/reactions/#{reaction.id}", params: valid_params.to_json, headers: headers
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the reaction" do
        reaction.reload
        expect(reaction.kind).to eq("love")
      end

      it "returns the updated reaction" do
        json_response = JSON.parse(response.body)
        expect(json_response["kind"]).to eq("love")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          reaction: {
            kind: "invalid_kind"
          }
        }
      end

      before do
        patch "/api/v1/reactions/#{reaction.id}", params: invalid_params.to_json, headers: headers
      end

      it "returns unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the reaction" do
        reaction.reload
        expect(reaction.kind).to eq("like")
      end
    end
  end

  describe "DELETE /api/v1/reactions/:id" do
    let!(:reaction) { Reaction.create!(kind: "like", user: user, reactionable: post_record) }

    it "deletes the reaction" do
      expect {
        delete "/api/v1/reactions/#{reaction.id}", headers: headers
      }.to change(Reaction, :count).by(-1)
    end

    it "returns no content status" do
      delete "/api/v1/reactions/#{reaction.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
