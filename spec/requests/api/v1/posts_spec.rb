require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }
  let!(:user) { User.create!(email: "author@example.com", password: "password123", name: "Author User") }

  describe "GET /api/v1/posts" do
    let!(:posts) do
      5.times.map { |i| Post.create!(title: "Post #{i}", content: "Content #{i}", author: user) }
    end

    before do
      get "/api/v1/posts", headers: headers
    end

    it "returns success status" do
      expect(response).to have_http_status(:ok)
    end

    it "returns all posts" do
      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to be_an(Array)
      expect(json_response["data"].length).to eq(5)
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
        get "/api/v1/posts?per_page=2&page=1", headers: headers
      end

      it "respects per_page parameter" do
        json_response = JSON.parse(response.body)
        expect(json_response["data"].length).to eq(2)
      end
    end
  end

  describe "GET /api/v1/posts/:id" do
    let!(:post) { Post.create!(title: "Test Post", content: "Test content", author: user) }

    context "when post exists" do
      before do
        get "/api/v1/posts/#{post.id}", headers: headers
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the post" do
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(post.id)
        expect(json_response["title"]).to eq("Test Post")
        expect(json_response["content"]).to eq("Test content")
      end
    end

    context "when post does not exist" do
      before do
        get "/api/v1/posts/99999", headers: headers
      end

      it "returns not found status" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/posts" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          post: {
            title: "New Post",
            content: "New content",
            published: true,
            author_id: user.id
          }
        }
      end

      it "creates a new post" do
        expect {
          post "/api/v1/posts", params: valid_params.to_json, headers: headers
        }.to change(Post, :count).by(1)
      end

      it "returns created status" do
        post "/api/v1/posts", params: valid_params.to_json, headers: headers
        expect(response).to have_http_status(:created)
      end

      it "returns the created post" do
        post "/api/v1/posts", params: valid_params.to_json, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response["title"]).to eq("New Post")
        expect(json_response["content"]).to eq("New content")
        expect(json_response["published"]).to eq(true)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          post: {
            title: "",
            content: ""
          }
        }
      end

      it "does not create a post" do
        expect {
          post "/api/v1/posts", params: invalid_params.to_json, headers: headers
        }.not_to change(Post, :count)
      end

      it "returns unprocessable entity status" do
        post "/api/v1/posts", params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        post "/api/v1/posts", params: invalid_params.to_json, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "PATCH /api/v1/posts/:id" do
    let!(:post_record) { Post.create!(title: "Original Title", content: "Original content", author: user) }

    context "with valid parameters" do
      let(:valid_params) do
        {
          post: {
            title: "Updated Title",
            content: "Updated content"
          }
        }
      end

      before do
        patch "/api/v1/posts/#{post_record.id}", params: valid_params.to_json, headers: headers
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the post" do
        post_record.reload
        expect(post_record.title).to eq("Updated Title")
        expect(post_record.content).to eq("Updated content")
      end

      it "returns the updated post" do
        json_response = JSON.parse(response.body)
        expect(json_response["title"]).to eq("Updated Title")
        expect(json_response["content"]).to eq("Updated content")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          post: {
            title: ""
          }
        }
      end

      before do
        patch "/api/v1/posts/#{post_record.id}", params: invalid_params.to_json, headers: headers
      end

      it "returns unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the post" do
        post_record.reload
        expect(post_record.title).to eq("Original Title")
      end
    end
  end

  describe "DELETE /api/v1/posts/:id" do
    let!(:post_record) { Post.create!(title: "To Delete", content: "Delete me", author: user) }

    it "deletes the post" do
      expect {
        delete "/api/v1/posts/#{post_record.id}", headers: headers
      }.to change(Post, :count).by(-1)
    end

    it "returns no content status" do
      delete "/api/v1/posts/#{post_record.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
