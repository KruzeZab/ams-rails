module Api
  module V1
    class Api::V1::UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          render_success(message: "User created successfully", data: user, status: :created)
        else
          render_error(message: "User creation failed", errors: user.errors.full_messages)
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :first_name, :last_name, :email, :phone, :password, :dob,
          :gender, :address, :role
        )
      end
    end
  end
end
