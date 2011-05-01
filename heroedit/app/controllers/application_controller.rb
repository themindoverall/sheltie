class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def editor(filename="")
    @libraries = (Dir.foreach('assets/objects').collect do |file|
      if file[0] != '.'
        File.basename(file, '.json')
      end
    end).compact()
    
    @level = nil
    fn = params[:filename]
    if fn
      file = File.new('assets/levels/' + fn + '.sheltie')
      @level = file.read
      @levelname = fn
      file.close
    end
    
  end
  
  def save()
    level = params[:level]
    filename = params[:filename] + '.sheltie'
    
    File.open('assets/levels/' + filename, 'w') { |f|
      f.write(level.to_json())
    }
    
    render :text => 'save successful'
  end
  
  def load_objects()
    fn = params[:filename]
    file = File.new('assets/objects/' + fn + '.json')
    contents = file.read
    puts contents
    render :text => contents, :content_type => 'application/json'
  end
end
