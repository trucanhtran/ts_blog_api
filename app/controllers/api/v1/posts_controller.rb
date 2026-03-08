module Api
  module V1
    class PostsController < ::Api::BaseController
      before_action :set_post, only: [ :show, :update, :destroy ]

      # GET /api/v1/posts
      def index
        posts = Post.all
        paginated = paginate(posts, params[:per_page] || 20)

         json_response(
          paginated[:data],
          each_serializer: PostSerializer,
          meta: paginated[:meta]
        )
      end

      # GET /api/v1/posts/:id
      def show
        json_response(@post, serializer: PostSerializer)
      end

      # POST /api/v1/posts
      def create
        post = Post.new(post_params)

        if post.save
          json_response(post, serializer: PostSerializer, status: :created)
        else
          json_response({ errors: post.errors.full_messages }, :unprocessable_entity)
        end
      end

      # PATCH/PUT /api/v1/posts/:id
      def update
        if @post.update(post_params)
          json_response(@post, serializer: PostSerializer)
        else
          json_response({ errors: @post.errors.full_messages }, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/posts/:id
      def destroy
        @post.destroy!
        head :no_content
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :content, :published)
      end
    end
  end
end
