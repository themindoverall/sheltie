class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def editor(filename="")
    
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
end
