module SessionsHelper

	def sign_in(user)
		cookies[:remember_token] = user.remember_token
		self.current_user = user
	end

	def signed_in?
		!self.current_user.nil?
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user=(user)
		@current_user = user
	end

	# Slightly modified from tutorial to protect against user in db with null remember_token
	def current_user
		if @current_user then
			@current_user
		elsif (cookies[:remember_token]) then
			@current_user = User.find_by_remember_token(cookies[:remember_token])
		else
			nil
		end
	end
end