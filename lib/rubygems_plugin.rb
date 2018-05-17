Gem.post_install do
  %x(#{File.dirname(__FILE__) + '/../install.bash'})

  $?.success?
end
