require 'rails_helper'

RSpec.describe "Api::V1::Comments", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }
  let!(:user) { User.create!(email: "user@example.com", password: "password123", name: "Test User") }
  let!(:post_record) { Post.create!(title: "Test Post", content: "Test content", author: user) }

  describe "GET /api/v1/comments" do
    let!(:comments) do
      3.times.map { |i| Comment.create!(content: "Comment #{i}", post: post_record, author: user) }
    end

    before do
      get "/api/v1/comments", headers: headers
    end

    it "returns success status" do
      expect(response).to have_http_status(:ok)
    end

    it "returns all comments" do
      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to be_an(Array)
      expect(json_response["data"].length).to eq(3)
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
        get "/api/v1/comments?per_page=2&page=1", headers: headers
      end

      it "respects per_page parameter" do
        json_response = JSON.parse(response.body)
        expect(json_response["data"].length).to eq(2)
      end
    end
  end

  describe "GET /api/v1/comments/:id" do
    let!(:comment) { Comment.create!(content: "Test comment", post: post_record, author: user) }

    context "when comment exists" do
      before do
        get "/api/v1/comments/#{comment.id}", headers: headers
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the comment" do
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(comment.id)
        expect(json_response["content"]).to eq("Test comment")
      end
    end

    context "when comment does not exist" do
      before do
        get "/api/v1/comments/99999", headers: headers
      end

      it "returns not found status" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/comments" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          comment: {
            content: "New comment",
            post_id: post_record.id,
            author_id: user.id
          }
        }
      end

      it "creates a new comment" do
        expect {
          post "/api/v1/comments", params: valid_params.to_json, headers: headers
        }.to change(Comment, :count).by(1)
      end

      it "returns created status" do
        post "/api/v1/comments", params: valid_params.to_json, headers: headers
        expect(response).to have_http_status(:created)
      end

      it "returns the created comment" do
        post "/api/v1/comments", params: valid_params.to_json, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response["content"]).to eq("New comment")
        expect(json_response["post_id"]).to eq(post_record.id)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          comment: {
            content: "",
            post_id: nil,
            author_id: user.id
          }
        }
      end

      it "does not create a comment" do
        expect {
          post "/api/v1/comments", params: invalid_params.to_json, headers: headers
        }.not_to change(Comment, :count)
      end

      it "returns unprocessable entity status" do
        post "/api/v1/comments", params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        post "/api/v1/comments", params: invalid_params.to_json, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "PATCH /api/v1/comments/:id" do
    let!(:comment) { Comment.create!(content: "Original content", post: post_record, author: user) }

    context "with valid parameters" do
      let(:valid_params) do
        {
          comment: {
            content: "Updated content"
          }
        }
      end

      before do
        patch "/api/v1/comments/#{comment.id}", params: valid_params.to_json, headers: headers
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the comment" do
        comment.reload
        expect(comment.content).to eq("Updated content")
      end

      it "returns the updated comment" do
        json_response = JSON.parse(response.body)
        expect(json_response["content"]).to eq("Updated content")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          comment: {
            content: ""
          }
        }
      end

      before do
        patch "/api/v1/comments/#{comment.id}", params: invalid_params.to_json, headers: headers
      end

      it "returns unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the comment" do
        comment.reload
        expect(comment.content).to eq("Original content")
      end
    end
  end

  describe "DELETE /api/v1/comments/:id" do
    let!(:comment) { Comment.create!(content: "To delete", post: post_record, author: user) }

    it "deletes the comment" do
      expect {
        delete "/api/v1/comments/#{comment.id}", headers: headers
      }.to change(Comment, :count).by(-1)
    end

    it "returns no content status" do
      delete "/api/v1/comments/#{comment.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
