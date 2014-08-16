namespace :crawler do
  desc "crawling dgtle"
  task :dgtle do
    ruby "./lib/crawler/dgtle.rb"
  end

  desc "crawling fengniao"
  task :fengniao do
    ruby "./lib/crawler/fengniao.rb"
  end

  desc "crawling macx"
  task :macx do
    ruby "./lib/crawler/macx.rb"
  end

  desc "crawling v2ex"
  task :v2ex do
    ruby "./lib/crawler/v2ex.rb"
  end

  desc "crawling feng"
  task :feng do
    ruby "./lib/crawler/feng.rb"
  end
end
