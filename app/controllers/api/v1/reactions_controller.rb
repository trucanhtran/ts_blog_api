module Api
  module V1
    class ReactionsController < ::Api::BaseController
      before_action :set_reaction, only: [:show, :update, :destroy]

      # GET /api/v1/reactions
      def index
        reactions = Reaction.all
        paginated = paginate(reactions, params[:per_page] || 20)

        json_response(
          paginated[:data],
          each_serializer: ReactionSerializer,
          meta: paginated[:meta]
        )
      end

      # GET /api/v1/reactions/:id
      def show
        json_response(@reaction, serializer: ReactionSerializer)
      end

      # POST /api/v1/reactions
      def create
        reaction = Reaction.new(reaction_params)

        if reaction.save
          json_response(
            reaction,
            serializer: ReactionSerializer,
            status: :created
          )
        else
          json_response({ errors: reaction.errors.full_messages }, status: :unprocessable_entity)
        end
      end

      # PATCH/PUT /api/v1/reactions/:id
      def update
        if @reaction.update(reaction_params)
          json_response(@reaction, serializer: ReactionSerializer)
        else
          json_response({ errors: @reaction.errors.full_messages }, status: :unprocessable_entity)
        end
      end

      # DELETE /api/v1/reactions/:id
      def destroy
        @reaction.destroy!
        head :no_content
      end

      private

      def set_reaction
        @reaction = Reaction.find(params[:id])
      end

      def reaction_params
        params.require(:reaction).permit(:kind, :user_id, :reactionable_type, :reactionable_id)
      end
    end
  end
end
