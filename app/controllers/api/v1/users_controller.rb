class Api::V1::UsersController < ApplicationController
	before_action :set_user, only: %i[show update destroy]
	before_action :check_owner, only: %i[update destroy]
	rescue_from JWT::VerificationError, with: :signature_verification_raised

	# GET /users/1
	def show
		options = { include: [:products] }
		render json: UserSerializer.new(@user, options).serializable_hash.to_json
	end

	# PATCH/PUT /users/1
	def update
		if @user.update(user_params)
			render json:
			UserSerializer.new(@user).serializable_hash.to_json
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	def create
		@user = User.new(user_params)

		if @user.save
			render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	# DELETE /users/1
	def destroy
		@user.destroy
		head 204
	end

	private

	def check_owner
		head :forbidden unless @user.id == current_user&.id
	end

	# Only allow a trusted paramaeter "white list" through.
	def user_params
		params.require(:user).permit(:email, :password)
	end

	def signature_verification_raised
		render plain: "Given Token is invalid because it has perished/malformed.", status: :forbidden
	end

	def set_user
		@user = User.find(params[:id])
	end

end
