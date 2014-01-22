module SessionsHelper
  def current_user
    @current_user ||= User.friendly.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user?(user)
    current_user == user
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
  end

  private

  def ensure_user_logged_in
    puts "S 24"
    unless logged_in?
      flash[:warning] = 'Not logged in.'
      redirect_to login_path
    end
  end

  def ensure_user_logged_out
    puts "S 32"
    unless !logged_in?
      flash[:warning] = 'You are already logged in.'
      redirect_to root_path
    end
  end

  def ensure_contest_creator
    puts "S 40"
    unless current_user.contest_creator?
      flash[:danger] = 'Not a contest creator.'
      redirect_to root_path
    end
  end

  def ensure_correct_user(user_id = params[:id])
    puts "S 48"
    @user = User.friendly.find(user_id)
    unless current_user?(@user)
      flash[:danger] = 'Unable to edit another user\'s stuff.'
      redirect_to root_path
    end
  end

end
