class SprocketsOnHeroku
  
  def self.original_sprockets_location
    @@original_sprockets_location ||= nil
  end

  def self.original_sprockets_location=(location)
    @@original_sprockets_location = location
  end

  def self.uri
    @@uri ||= '/sprockets.js'
  end

  def self.uri=(uri)
    @@uri = uri
  end
  
  def initialize(app)
    @app = app
    initialize_sprockets unless self.class.original_sprockets_location
  end

  def call(env)
    if env['PATH_INFO'] == self.class.uri
      return render_sprockets
    end
    @app.call(env)
  end

  def render_sprockets
    [
      200,
      {
        'Cache-Control'  => 'public, max-age=86400',
        'Content-Length' => File.size(javascript_location_on_heroku).to_s,
        'Content-Type'   => 'text/javascript'
      },
      File.read(javascript_location_on_heroku)
    ]
  end

  protected
  def initialize_sprockets
    secretary.concatenation.save_to(javascript_location_on_heroku)
    minify
    self.class.original_sprockets_location = '/sprockets.js' 
  end

  def minify
    begin
      require 'jsmin'
      js = File.read(javascript_location_on_heroku)
      File.open(javascript_location_on_heroku, 'w') { |f| f.write(JSMin.minify(js)) }
    rescue LoadError
    end
  end

  def secretary
    @secretary ||= Sprockets::Secretary.new(configuration.merge(:root => Rails.root))
  end

  def configuration
    YAML.load(IO.read(Rails.root.join('config', 'sprockets.yml'))) || {}
  end

  def javascript_location_on_heroku
    Rails.root.join('tmp', 'sprockets.js').to_s
  end
end
