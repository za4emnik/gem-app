class MainController < Controller

  attr_reader :response

  def initialize(env)
    @session = env['rack.session']
    @request = Rack::Request.new(env)
    @irb = RenderIRB.new(self)
    @session['errors'] = Array.new unless @session['errors'].kind_of?(Array)
    unless @session['game']
      @session['game'] = CodebreakerGem::Game.new
      @session['game'].generate_code
    end
  end

  def index
    save_name if @request.post?
    return redirect_to('/run') if @session['player']
    @irb.render 'wellcome', 'guest'
  end

  def run
    return you_lose if @session['game'].attempts <= 0
    @irb.render 'index'
  end

  def hint
    @session['game'].get_hint if @session['game'].hints > 0
  end

  def check
    return you_won if @session['game'].secret_code == @request.params['guess']
    if @request.params['guess'] =~ /\A[1-6]{4}\z/
      @session['game'].guess = @request.params['guess']
      @session['game'].check
    else
      set_error 'Guess may include only the digits 1 to 6'
    end
    redirect_to('/run')
  end

  def you_won
    save_game
    remove_game
    @irb.render 'congrats'
  end

  def you_lose
    remove_game
    @irb.render 'lose'
  end

  def new_game
    remove_game
  end

  def quit
    remove_game
    @session['player'] = nil
  end

  def save_game
    scores = @session['game'].get_scores
    scores[:user_name] = @session['player']
    @session['game'].save_achievement(scores)
  end

  def save_name
    unless @request.params['player_name'].empty?
      @session['player'] = @request.params['player_name']
    else
      set_error 'Name can\'t be empty!'
      redirect_to ('/')
    end
  end

  def achievements
    @achievements = CodebreakerGem::Game.new.read_achievements
    @irb.render 'achievements'
  end

  def set_error(error)
    @session['errors'].push(error)
  end

  def remove_errors
    @session['errors'] = nil
  end

  after_filter 'redirect_to_run', 'hint', 'quit', 'new_game'
  before_filter 'check_name', 'run', 'you_won', 'check', 'hint'


  private


  def remove_game
    @session['game'] = nil
  end

  def check_name
    @response = redirect_to('/') unless @session['player']
  end

  def redirect_to_run
    @response = redirect_to('/run')
  end
end
