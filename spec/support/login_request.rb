module SignInRequest
  def sign_in_request(user)
    session_params = {session: {email: user.email, password: user.password}}
    post user_session_path, params: session_params
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({id: user.id})
  end
end