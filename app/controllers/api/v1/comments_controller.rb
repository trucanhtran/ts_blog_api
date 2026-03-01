module Api
  module V1
    class CommentsController < ::Api::BaseController
      before_action :set_comment, only: [ :show, :update, :destroy ]

      # GET /api/v1/comments
      def index
        comments = Comment.all
        paginated = paginate(comments, params[:per_page] || 20)

        json_response({
          data: ActiveModelSerializers::SerializableResource.new(
            paginated[:data],
            each_serializer: CommentSerializer
          ),
          meta: paginated[:meta]
        })
      end

      # GET /api/v1/comments/:id
      def show
        json_response(
          ActiveModelSerializers::SerializableResource.new(@comment, serializer: CommentSerializer)
        )
      end

      # POST /api/v1/comments
      def create
        comment = comment.new(comment_params)

        if comment.save
          json_response(
            ActiveModelSerializers::SerializableResource.new(comment, serializer: CommentSerializer),
            :created
          )
        else
          json_response({ errors: comment.errors.full_messages }, :unprocessable_entity)
        end
      end

      # PATCH/PUT /api/v1/comments/:id
      def update
        if @comment.update(comment_params)
            json_response(
              ActiveModelSerializers::SerializableResource.new(@comment, serializer: CommentSerializer)
            )
        else
            json_response({ errors: @comment.errors.full_messages }, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/comments/:id
      def destroy
        @comment.destroy!
        head :no_content
      end

      private

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:content, :post_id, :user_id)
      end
    end
  end
end
