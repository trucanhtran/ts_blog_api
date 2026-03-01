module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json
        # CSRF handled globally by Api::BaseController

        # POST /api/v1/login
        def create
          user_params = params.require(:user).permit(:email, :password)
          user = User.find_for_authentication(email: user_params[:email])

          if user&.valid_password?(user_params[:password])
            # do not write to server-side session when using JWT
            sign_in(user, store: false)
            render json: { message: 'Logged in successfully.', user: UserSerializer.new(user) }, status: :ok
          else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        end

        private

        def respond_with(resource, _opts = {})
          render json: { message: 'Logged in successfully.', user: UserSerializer.new(resource) }, status: :ok
        end

        # Devise may pass the resource or other args when calling this, so
        # accept splat.
        def respond_to_on_destroy(*)
          if current_user
            render json: { message: 'Logged out successfully.' }, status: :ok
          else
            render json: { message: 'User has no active session' }, status: :unauthorized
          end
        end
      end
    end
  end
end
