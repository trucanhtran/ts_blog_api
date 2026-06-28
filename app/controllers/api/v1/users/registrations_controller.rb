module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        # POST /api/v1/signup
        def create
          build_resource(sign_up_params)
          resource.save
          if resource.persisted?
            sign_in(resource, store: false)
            render json: { message: "Signed up successfully.", user: UserSerializer.new(resource) }, status: :created
          else
            clean_up_passwords(resource)
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation, :name, :bio)
        end

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: { message: "Signed up successfully.", user: UserSerializer.new(resource) }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
