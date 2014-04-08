class StaticPagesController < ApplicationController
  def home
  end
  
  def contact
  end

  def team
  end
  
  def clients
  end
  
  def services
  end
  
  def publications
  end

  def guide
    path = "#{Rails.root}/public/assets/Users_Manual_4_7_2014.pdf"	
    path = "#{Rails.root}/app/views/static_pages/Users_Manual_4_7_2014.pdf"	

      send_file( path,
        :disposition => 'inline',
        :type => 'application/pdf',
        :x_sendfile => true )
  end

end
