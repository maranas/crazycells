Pod::Spec.new do |s|
  s.name         = "crazycells"
  s.version      = "1.0"
  s.summary      = "UITableView scroll animations in Swift"
  s.description  = <<-DESC
                   crazycells contains GLSTableViewCell, a subclass of UITableViewCell,
                   a table view cell with custom animations on appearance. Cells can zoom
                   in, slide in, flip in on appearance. It's easy to use too, just subclass
                   GLSTableViewCell for your table view cells, and just set the animationType
                   and call animateIn() on the instance.
                   DESC
  s.homepage     = "https://github.com/maranas/crazycells"
  s.screenshots  = "http://i.imgur.com/ujTCzYD.gif", "http://i.imgur.com/QTng17U.gif", "http://i.imgur.com/lGN10st.gif", "http://i.imgur.com/CcHOA0e.gif", "http://i.imgur.com/3jCyfAa.gif", "http://i.imgur.com/YkDy3AG.gif" 
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Moises" => "moises@ganglionsoftware.com" }
  s.platform     = :ios, '9.0'
  s.source       = { :git => "https://github.com/maranas/crazycells.git", :tag => "1.0" }
  s.source_files  = "crazycells/GLSTableViewCell.swift"
  s.frameworks = 'UIKit'
end
