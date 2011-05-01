class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def editor(filename="")
    @libraries = (Dir.foreach('assets/objects').collect do |file|
      if file[0] != '.'
        File.basename(file, '.json')
      end
    end).compact()
    
  end
  
  def save()
    level = {
      'name' => params[:filename],
      'width' => params[:width],
      'height' => params[:height],
      'map' => params[:map].gsub(/\\n/, "\n")
    }
    
    filename = params[:filename] + '.sheltie'
    
    File.open(filename, 'w') { |f|
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
